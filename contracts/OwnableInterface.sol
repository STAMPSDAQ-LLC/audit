// contracts/StampTokenSale.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
abstract contract Ownable {
  address payable public _owner;
  address payable public _coOwner1;
  address payable public _coOwner2;
  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() {
    _owner = payable(msg.sender);
    _coOwner1 = payable(0);
    _coOwner2 = payable(0);
  }
  /**
   * @dev Consistently sets co-owner1 and co-owner2 when creator calling
   */
  function addCoOwner(address payable coOwner) onlyCreator public{
    require(coOwner != payable(0), "Insane given address");
    require(_coOwner2 == payable(0), "Co-owners already set");
    if(_coOwner1 == payable(0)) {
      _coOwner1 = coOwner;
    } else {
      _coOwner2 = coOwner;
    }
  }
  /**
  * @dev Continues only if contract ownership was fully established
  */
  modifier validOwners() {
    require(_coOwner1 != address(0), "There is no co-owner1 for contract safety");
    require(_coOwner2 != address(0), "There is no co-owner2 for contract safety");
    _;
  }
  /**
  * @dev Continues only if callee in owners and all owners was set
  */
  modifier onlyOwner() {
    require(_coOwner1 != address(0), "Set co-owners");
    require(_coOwner2 != address(0), "Set all co-owners");
    if(msg.sender == _owner || msg.sender == _coOwner1 || msg.sender == _coOwner2) {
      _;
    }
  }
  /**
  * @dev Continues only if callee is contract creator
  */
  modifier onlyCreator() {
    require(msg.sender == _owner);
    _;
  }
}