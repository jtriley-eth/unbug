// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/mocks/UnbugMock.sol";
import "src/LibUnbug.sol";

contract LibUnbugTest is Test {
    using LibUnbug for address;

    address unbug;

    function setUp() public {
        unbug = address(new UnbugMock());
    }

    function testMemoryDump() public {
        bytes memory expectedMemory = abi.encodePacked(
            // scratchspace 0
            uint256(0x00),
            // scratchspace 1
            uint256(0x00),
            // free memory pointer
            uint256(0x140),
            // zero slot
            uint256(0x00),
            // arr
            abi.encode(uint256(3), [uint256(0x42), uint256(0x69), uint256(0x0420)]),
            // str.length
            uint256(0x16),
            // str
            "busl isn't open source",
            // str padding
            uint80(0x00)
        );

        assertEq(keccak256(unbug.memoryDump(abi.encodeWithSignature("memoryStuffs()"))), keccak256(expectedMemory));
    }

    function testCalldataDump() public {
        uint256[] memory arr = new uint256[](3);
        arr[0] = 0x42;
        arr[1] = 0x69;
        arr[2] = 0x0420;
        bytes memory callData =
            abi.encodeWithSignature("calldataStuffs(uint256[],string)", arr, "busl isn't open source");

        assertEq(keccak256(unbug.calldataDump(callData)), keccak256(callData));
    }

    function testStorageDump() public {
        bytes memory expectedStoragae = abi.encodePacked(uint256(0x42), uint256(0x69), uint256(0x0420));

        assertEq(keccak256(unbug.storageDump(abi.encodeWithSignature("storageStuffs()"))), keccak256(expectedStoragae));
    }
}
