// contracts/Postdollar.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Postdollar is ERC20 {
    constructor(uint256 initialSupply) ERC20("POSTUSD", "PUSD") {
        _mint(msg.sender, initialSupply);
    }

    function transferToContract(address recipient, uint256 amount)
        public
        returns (bool) 
        {
            _transfer(_msgSender(), recipient, amount);
            Seller sc = Seller(recipient);
            sc.validatePayment(address(this), _msgSender(), amount);
            return true;
        }
}

    abstract contract Seller {
        function validatePayment(address initiator, address sender, uint256 amount) virtual public returns(bool);
    }