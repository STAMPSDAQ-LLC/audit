// contracts/Helpers.sol
// STAMPSDAQ
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

library Concat {
    /**
    * @dev Helper function for concatenating string 'a' to string 'b' into 'ab'
    */
    function _concat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
}

library uintToString { 
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
}

library stringCompare {
    /**
    * @dev Hepler function to compare string values
    */
    function _compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}