// contracts/Stamptoken
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {Concat, uintToString} from "./Helpers.sol";

/**
 * @title StampToken
 * StampToken - ERC721 token contract.
 * Represents stamps and art in STAMPSDAQ system
 */
contract StampToken is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Concat for string;
    using uintToString for uint;
    /**
    * @dev Contract Constructor
    */
    constructor() ERC721("STAMPSDAQ-Stamp", "SSTMP") {}
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
        _setTokenURI(newItemId, baseURI._concat(newItemId._uintToString()));
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
            _setTokenURI(itemId, baseURI._concat(itemId._uintToString()));
        }
        return itemId;
    }
}