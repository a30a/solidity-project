const Web3 = require('web3');

let BToken = artifacts.require("BToken")

module.exports = function(deployer) {
  deployer.deploy(BToken, Web3.utils.toWei('100', 'ether'));
}
