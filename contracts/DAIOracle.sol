pragma solidity =0.6.6;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';

// fixed window oracle that recomputes the average price for the entire period once every period
// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
contract DAIOracle {
    using FixedPoint for *;

    uint public constant PERIOD = 2 minutes;

    IUniswapV2Pair immutable pair0;
    IUniswapV2Pair immutable pair1;
    address public immutable token0;
    address public immutable token1;
    address public immutable tokenDAI;

    uint    public price0CumulativeLast;
    uint    public price1CumulativeLast;
    uint    public priceDAI1CumulativeLast;
    uint    public priceDAI2CumulativeLast;
    uint32  public blockTimestampLast;

    FixedPoint.uq112x112 public price0Average;
    FixedPoint.uq112x112 public price1Average;
    FixedPoint.uq112x112 public priceDAI1Average;
    FixedPoint.uq112x112 public priceDAI2Average;

    constructor(address factory, address tokenA, address tokenB, address dai) public {
        // Set A
        IUniswapV2Pair _pair0 = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, dai));
        pair0 = _pair0;
        token0 = _pair0.token0();
        tokenDAI = _pair0.token1();
        price0CumulativeLast = _pair0.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
        priceDAI1CumulativeLast = _pair0.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
        uint112 reserve0;
        uint112 reserve1;
        (reserve0, reserve1, blockTimestampLast) = _pair0.getReserves();
        require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair


        // Set B
        IUniswapV2Pair _pair1 = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenB, dai));
        pair1 = _pair1;
        token1 = _pair1.token0();
        //  if tokenDAI == _pair1.token1() true??
        price1CumulativeLast = _pair1.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
        priceDAI2CumulativeLast = _pair1.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
        uint112 reserve2;
        uint112 reserve3;
        (reserve2, reserve3, blockTimestampLast) = _pair1.getReserves();
        require(reserve2 != 0 && reserve3 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair
    }

    function update() external {
        (uint price0Cumulative, uint priceDAI1Cumulative, uint32 blockTimestamp) =
            UniswapV2OracleLibrary.currentCumulativePrices(address(pair0));
        (uint price1Cumulative, uint priceDAI2Cumulative, uint32 blockTimestamp1) =
        UniswapV2OracleLibrary.currentCumulativePrices(address(pair1));

        require(blockTimestamp == blockTimestamp1, 'blockTimestamp must be same');
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired

        // ensure that at least one full period has passed since the last update
        require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
        price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));
        priceDAI1Average = FixedPoint.uq112x112(uint224((priceDAI1Cumulative - priceDAI1CumulativeLast) / timeElapsed));
        priceDAI2Average = FixedPoint.uq112x112(uint224((priceDAI2Cumulative - priceDAI2CumulativeLast) / timeElapsed));

        price0CumulativeLast = price0Cumulative;
        price1CumulativeLast = price1Cumulative;
        priceDAI1CumulativeLast = priceDAI1Cumulative;
        priceDAI2CumulativeLast = priceDAI2Cumulative;
        blockTimestampLast = blockTimestamp;
    }

    // note this will always return 0 before update has been called successfully for the first time.
    function consult(address token, uint amountIn) external view returns (uint amountOut) {
        if (token == token0) {
            amountOut = price0Average.mul(amountIn).decode144();
        } else {
            require(token == token1, 'ExampleOracleSimple: INVALID_TOKEN');
            amountOut = price1Average.mul(amountIn).decode144();
        }
    }

    function consultDAI(uint amountIn) external view returns (uint amount1Out, uint amount2Out) {
            amount1Out = priceDAI1Average.mul(amountIn).decode144();
            amount2Out = priceDAI2Average.mul(amountIn).decode144();
    }
}