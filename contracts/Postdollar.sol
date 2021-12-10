// contracts/Postdollar.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Postdollar
 * Postdollar - ERC20 token contract for deploying in outer nets.
 * Turns into native across the bridge
 */
contract Postdollar is ERC20 {
    
     /**
    * @dev Contract Constructor
    * @param initialSupply defines total minting amount when contract created
    */
    constructor(uint256 initialSupply) ERC20("POSTUSD", "PUSD") {
        _mint(msg.sender, initialSupply);
    }
}