// contracts/StampTokenSale.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./DestructibleInterface.sol";
import "./StampToken.sol";
import "./RewardPool.sol";
import "./ComissionManager.sol";


/**
 * @title StampTokenSale
 * StampTokenSale - a sales contract for saling STAMPSDAQ non-fungible tokens
 */
contract StampTokenSale is Ownable, Destructible {

    event Sent(address indexed payee, uint256 amount, uint256 balance);
    event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);

    StampToken public _nftAddress;
    uint256 public _price;
    uint256 public _tokenId;
    address payable public _tokenOwner;
    bool public _completed;
    bool public _sideSales;
    RewardPool public constant _rewardPool = RewardPool(payable(0x7723F94513c924b01E32cBa20C089fB3A4651228));
    ComissionManager public constant _comissionManager = ComissionManager(payable(0xA84547aB77A4d3C7611E9e860006FBC9b5a27b66));
    address payable public constant _addressSTAMPSDAQ = payable(0xb592CA282543581886B8d46fda05Aa9C5A421b0e);

    /**
    * @dev Contract Constructor
    * @param nftAddress address for STAMPSDAQ NFT contract address
    * @param tokenId for sale
    * @param price initial sales price
    */
    constructor(address nftAddress, uint256 tokenId, uint256 price) {
        require(nftAddress != address(0) && nftAddress != address(this), "Insane address given");
        require(price > 0, "Provide correct price");
        require(StampToken(nftAddress).ownerOf(tokenId) == msg.sender, "This is not your token");
        _sideSales = (msg.sender != _addressSTAMPSDAQ);
        _tokenOwner = payable(msg.sender);
        _nftAddress = StampToken(nftAddress);
        _tokenId = tokenId;
        _price = price;
        _completed = false;
    }

    /**
    * @dev Complete offer and buy token
    */
    function complete() validOwners public payable {
        require(msg.sender != address(0) && msg.sender != address(this), "Something nasty!");
        require(_completed == false, "Offer alrady completed");
        uint256 endPrice = 0;
        if(_sideSales != true) {
          endPrice = _price;
        } else {
          endPrice = ComissionManager(_comissionManager).getComissionedPrice(msg.sender, _price);
        }
        require(msg.value >= endPrice, "Too low value provided");
        require(StampToken(_nftAddress).ownerOf(_tokenId) == _tokenOwner, "Token owner was changed");
        require(StampToken(_nftAddress).getApproved(_tokenId) == address(this), "Token owner has not approved token");
        StampToken(_nftAddress).safeTransferFrom(_tokenOwner, msg.sender, _tokenId);
        uint256 rewardPoolDeposit = 0;
        if(_sideSales != true) {
          rewardPoolDeposit = endPrice * 2/10;
          RewardPool(_rewardPool).fill{value:rewardPoolDeposit}();
          _tokenOwner.transfer(address(this).balance);
        } else {
          rewardPoolDeposit = (endPrice - _price) * 2/10;
          _tokenOwner.transfer(_price);
          RewardPool(_rewardPool).fill{value:rewardPoolDeposit}();
          _addressSTAMPSDAQ.transfer(address(this).balance);
        }
        _completed = true;
        emit Received(msg.sender, _tokenId, msg.value, address(this).balance);
    } 
    /**
    * @dev Get price to complete contract (including comissions)
    */
    function getPayablePrice(address payable payer)
        public
        view
        returns (uint256) {
      return ComissionManager(_comissionManager).getComissionedPrice(payer, _price);
    }
    /**
    * @dev Fallback features
    */
    receive() external payable {
        require(false, "Use complete method");
    }

    fallback() external payable {
        require(false, "Use complete method");
    }
}