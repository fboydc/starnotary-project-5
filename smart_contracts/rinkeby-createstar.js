const artifacts = require('./build/contracts/StarNotary.json')
const truffleContract = require('truffle-contract')
const starNotary = truffleContract(artifacts);
starNotary.setProvider(web3.currentProvider);

var account_one = "0x12d21a9f48956204e6ea8e3180f2b8dbf6cc606a"; // an address

var meta;

starNotary.deployed().then(function(instance) {
  meta = instance;
  return meta.createStar("Kaipreb", 1, "dec_123", "mag_309", "ra_010.107", "There is an anomaly in this system. Scanning reveals a deposit of Element Zero.", {from: account_one});
}).then(function(result) {
  // If this callback is called, the transaction was successfully processed.
  alert("Transaction successful!")
}).catch(function(e) {
  // There was an error! Handle it.
})