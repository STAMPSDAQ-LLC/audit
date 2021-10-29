// contracts/StampTokenSale.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./OwnableInterface.sol";

/**
 * @title ComissionManager
 * ComissionManager - contract for global trading fee managing
 * fee values are decimal percentage values multiple by 100
 */
contract ComissionManager is Ownable {

    mapping(address => uint256) private _exclusiveComissions;
    uint256 public _globalComission;
    /**
    * @dev Contract Constructor
    */
    constructor() {  
        _globalComission = 333;
    }

    /**
    * @dev update global comission value for marketplace
    * @param newGlobalComission - new comission value
    */
    function updateGlobalComission(uint16 newGlobalComission) public onlyOwner {
        require(newGlobalComission > 0 && newGlobalComission <= 333);
        _globalComission = newGlobalComission;
    }

    /**
    * @dev set special comission on marketplace for one address
    * @param to - exclusive comission onwer
    * @param comission - new comission value for owner
    */
    function setExclusiveComission(address to, uint16 comission) public onlyOwner {
        require(to != address(0) && to != address(this));
        require(comission > 0 && comission <= 333);
        _exclusiveComissions[to] = comission;
    }
    /**
    * @dev get comission value for specified address
    * @param payerAddress - address for which comission calculated
    */
    function getComission(address payerAddress) public view returns (uint256) {
        require(payerAddress != address(0) && payerAddress != address(this));
        if(_exclusiveComissions[payerAddress] != 0) {
            return _exclusiveComissions[payerAddress];
        } else {
            return _globalComission;
        }
    }
    /**
    * @dev calculate price for specified address incl comissions
    * @param payerAddress - address for which comission calculated
    * @param price - initial price for calculating
    */
    function getComissionedPrice(address payerAddress, uint256 price) public view returns (uint256) {
        require(payerAddress != address(0) && payerAddress != address(this));
        if(_exclusiveComissions[payerAddress] != 0) {
            return (_exclusiveComissions[payerAddress] * price / 10000) + price;
        } else {
            return (_globalComission * price / 10000) + price;
        }
    }
    /**
    * @dev Fallback features
    */
    receive() external payable {
        require(false);
    }

    fallback() external payable {
        require(false);
    }
}