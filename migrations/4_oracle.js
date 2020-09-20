let DAIOracle = artifacts.require("DAIOracle")



module.exports = async function(deployer) {
  let uniswapFactory = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
  let AToken = "0xD40377f45cfDa5FA6d3C2BF3aA4DD92a6033e301"
  let BToken = "0x0c3cc276478e3298941Fd8b59f9753930f39C273"
  let DAI = "0xc2118d4d90b274016cb7a54c03ef52e6c537d957"

  deployer.deploy(DAIOracle, uniswapFactory, AToken, BToken, DAI);
}
