const Web3 = require('web3');

let AToken = artifacts.require("AToken")

module.exports = function(deployer) {
  deployer.deploy(AToken, Web3.utils.toWei('100', 'ether'));
}
