var MyNapoleonXToken = artifacts.require("NapoleonXToken");

const config = require("../config.json")

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyNapoleonXToken, config.END_DATE, {gas : 2100000, gasPrice : 60000000000});
};
