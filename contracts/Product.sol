pragma solidity ^0.4.19;

/**
 * this is just a really simple token so I have something to buy
 */
contract Product {
  /* This creates an array with all balances */
  mapping (address => uint256) public balances;

  /* Initialize contract with intial supply tokens to the creator of the contract. */
  function Product(uint256 initialSupply) public {
    balances[msg.sender] = initialSupply;           // Give the creator all initial tokens
  }

  /* Send coins */
  function transfer(address _to, uint256 _value) public {
    assert(balances[msg.sender] >= _value);          // Check if the sender has enough
    assert((balances[_to] + _value) >= balances[_to]); // Check for overflows
    balances[msg.sender] -= _value;                 // Subtract from the sender
    balances[_to] += _value;                        // Add the same to the recipient
  }
}
