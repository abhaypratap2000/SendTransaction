const ERC20TASK = artifacts.require("Token");

module.exports = function (deployer) {
  deployer.deploy(ERC20TASK);
};
