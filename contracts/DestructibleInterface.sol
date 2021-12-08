// contracts/StampTokenSale.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./OwnableInterface.sol";
/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
abstract contract Destructible is Ownable {

  mapping (address => address) private _destroyVotes;

  constructor() payable {
  }
  /**
  * @dev Calc owner votes and returns result
  */
  function getVotesDestroy(address payable addressToSend) private view returns(uint8) {
    uint8 votes = 0;
    if(_destroyVotes[_owner] == addressToSend) {
      votes += 1;
    }
    if(_destroyVotes[_coOwner1] == addressToSend) {
      votes += 1;
    }
    if(_destroyVotes[_coOwner2] == addressToSend) {
      votes += 1;
    }
    return votes;
  }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    _destroyVotes[msg.sender] = _owner;
    if(getVotesDestroy(_owner) >= 2) {
      selfdestruct(_owner);
    }
  }

  function destroyAndSend(address payable recipient) onlyOwner public {
    require(recipient != payable(0), "Insane given address");
    _destroyVotes[msg.sender] = recipient;
    if(getVotesDestroy(recipient) >= 2) {
      selfdestruct(recipient);
    }
  }
}