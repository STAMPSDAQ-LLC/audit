// contracts/StampTokenSale.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./OwnableInterface.sol";
/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
abstract contract Destructible is Ownable {

  constructor() payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    selfdestruct(_owner);
  }

  function destroyAndSend(address payable recipient) onlyOwner public {
    selfdestruct(recipient);
  }
}