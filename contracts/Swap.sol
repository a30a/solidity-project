pragma solidity =0.6.6;

import "./Atoken.sol";
import "./BToken.sol";

contract Swap {

    AToken a;
    BToken b;
    address oracle;

    constructor(AToken _a, BToken _b, address _oracle) public {
        a = _a;
        b = _b;
        oracle = _oracle;
    }

    function swapToB(uint256 amount) public {
        a.burn(msg.sender, amount);

        (bool success, bytes memory amountInDAI) = oracle.delegatecall(abi.encodeWithSignature("consult(address, uint)", address(a), amount));
        b.mint(msg.sender, abi.decode(amountInDAI, (uint)));
    }
    
    function swapToA(uint256 amount) public {
        b.burn(msg.sender, amount);

        (bool success, bytes memory amountInDAI) = oracle.delegatecall(abi.encodeWithSignature("consult(address, uint)", address(b), amount));
        a.mint(msg.sender, abi.decode(amountInDAI, (uint)));
    }
}