pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract NapoleonXToken is StandardToken {
  string public name = 'NapoleonX Token';
  string public symbol = 'NPX';
  uint8 public decimals = 2;
  uint public INITIAL_SUPPLY = 2980000000;

  uint public endTime;
  address napoleonXAdministrator;

  modifier only_napoleonXAdministrator {
    require(msg.sender == napoleonXAdministrator);
    _;
  }

  modifier is_earlier_than(uint x) {
      require(now < x);
      _;
  }

  function isEqualLength(address[] x, uint[] y) internal returns (bool) { return x.length == y.length; }
  modifier onlySameLengthArray(address[] x, uint[] y) {
      require(isEqualLength(x,y));
      _;
  }

  event TokenAllocated(address investor, uint tokenAmount);

  function NapoleonXToken(uint setEndTime) public {
    napoleonXAdministrator = msg.sender;
    totalSupply_= INITIAL_SUPPLY;
    balances[napoleonXAdministrator] = INITIAL_SUPPLY;
    endTime = setEndTime;
  }

  function populateWhitelisted(address[] whitelisted, uint[] tokenAmount) onlySameLengthArray(whitelisted, tokenAmount) only_napoleonXAdministrator {
    for (uint i = 0; i < whitelisted.length; i++) {
        transferFrom(napoleonXAdministrator, whitelisted[i], tokenAmount[i]);
    }
  }

  function updateWhitelisted(address[] whitelisted, uint[] tokenAmount) is_earlier_than(endTime) only_napoleonXAdministrator onlySameLengthArray(whitelisted, tokenAmount) {
    for (uint i = 0; i < whitelisted.length; i++) {
      uint previousAmount = balances[whitelisted[i]];
      balances[whitelisted[i]] = tokenAmount[i];
      totalSupply_ = totalSupply_-previousAmount+tokenAmount[i];
      TokenAllocated(whitelisted[i], tokenAmount[i]);
    }
}

function changeFounder(address newAdministrator) only_napoleonXAdministrator {
    napoleonXAdministrator = newAdministrator;
}




}
