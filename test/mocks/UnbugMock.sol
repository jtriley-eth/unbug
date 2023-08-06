// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "src/Unbug.sol";

contract UnbugMock is Unbug {
    uint256 storageSlot0 = 0x42;
    uint256 storageSlot1 = 0x69;
    uint256 storageSlot2 = 0x0420;

    function memoryStuffs() public pure {
        uint256[] memory arr = new uint256[](3);
        arr[0] = 0x42;
        arr[1] = 0x69;
        arr[2] = 0x0420;

        string memory str = "busl isn't open source";
        str;

        __memoryDump();
    }

    function calldataStuffs(uint256[] calldata arr, string calldata) public pure {
        uint256[] memory arr2 = arr;
        arr2[0] = 0x6969;
        __calldataDump();
    }

    function storageStuffs() public view {
        __storageDump(0x00, 0x03);
    }
}
