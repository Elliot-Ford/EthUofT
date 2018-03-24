pragma solidity ^0.4.19;

contract IOU {

  struct Buyer {
    mapping (address => uint) freeLoaders;
  }

  mapping(address => mapping(address => uint)) public buyers;

  /**
   * stores the amount owed to the current buyer by each freeloader.
   * Also updates the debt the buyer has to any of the freeloaders.
   */
  function setBuyer(address _address, address[] _freeLoaders, uint256 _amount) private {
    for(uint i = 0; i < _freeLoaders.length; i++) {
      // TODO: this probably could be simplified
      uint256 owing = buyers[_freeLoaders[i]][_address] + _amount; // the amount the buyer owes the current freeloader
      uint256 owed = buyers[_address][_freeLoaders[i]];
        if(owing > owed) {
          buyers[_freeLoaders[i]][_address] = owing - owed;
          buyers[_address][_freeLoaders[i]] = 0;
        } else if(owing < owed) {
          buyers[_freeLoaders[i]][_address] = 0;
          buyers[_address][_freeLoaders[i]] = owed - owing;
        } else {
          buyers[_freeLoaders[i]][_address] = 0;
          buyers[_address][_freeLoaders[i]] = 0;
        }
    }
  }


  function makeSplitCostTransfer(address _to, address _buyer, address[] _freeLoaders, uint256 _amount) public {
    assert(_buyer.balance >= _amount);            // Check if the sender has enough
    assert(_to.balance + _amount >= _to.balance); // Check for overflows
    _to.transfer(_amount);
    setBuyer(_buyer, _freeLoaders, _amount / (_freeLoaders.length + 1));
  }

}
