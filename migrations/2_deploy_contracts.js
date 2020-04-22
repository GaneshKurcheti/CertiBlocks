var Users = artifacts.require("./Users.sol");
var CertiBlocks = artifacts.require("./CertiBlocks.sol");

module.exports = function(deployer) {
  deployer.deploy(Users);
  deployer.deploy(CertiBlocks);
};
