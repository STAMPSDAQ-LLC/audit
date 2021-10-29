// contracts/Stamptoken
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title StampToken
 * StampToken - ERC721 token contract.
 * Represents stamps and art in STAMPSDAQ system
 */
contract StampToken is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
    * @dev Contract Constructor
    */
    constructor() ERC721("STAMPSDAQ-Stamp", "SSTMP") {}

    /**
    * @dev Helper function for concatenating string 'a' to string 'b' into 'ab'
    */
    function _concat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
    /**
    * @dev Helper function for stringify integer values
    */
    function _uintToString(uint value) internal pure returns (string memory) {
        uint maxlength = 40;
        bytes memory reversed = new bytes(maxlength);
        uint8 i = 0;
        while (value != 0) {
            uint remainder = value % 10;
            value = value / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        return string(s);
    }

    /**
    * @dev mints next in sequence token
    * @param owner - first token owner
    * @param baseURI - prefix to URI before token id
    */
    function singleEmission(address owner, string memory baseURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(owner, newItemId);
        _setTokenURI(newItemId, _concat(baseURI,_uintToString(newItemId)));
        return newItemId;
    }

    /**
    * @dev mints multiple sequential tokens
    * @param owner - first tokens owner
    * @param baseURI - prefix to URI before token id
    * @param amount - number of tokens to be minted
    */
    function multipleEmission(address owner, string memory baseURI, uint8 amount)
        public
        returns (uint256)
    {
        uint256 itemId;
        for (uint8 i=0; i < amount; i++) {
            _tokenIds.increment();
            itemId = _tokenIds.current();
            _mint(owner, itemId);
            _setTokenURI(itemId, _concat(baseURI,_uintToString(itemId)));
        }
        return itemId;
    }
}