const Swap = artifacts.require("Swap");

module.exports = function (deployer) {
  let AToken = "0xD40377f45cfDa5FA6d3C2BF3aA4DD92a6033e301"
  let BToken = "0x0c3cc276478e3298941Fd8b59f9753930f39C273"
  let oracle = "0xD9950c3ad1b243A91f2EA7948d41aE5625025fC5"

  deployer.deploy(Swap, AToken, BToken, oracle);
};
