// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Unbug Abstract Contract
/// @author jtriley.eth
/// @dev Inherited for debugging. DO NOT USE IN PRODUCTION. Each function will halt execution.
abstract contract Unbug {
    /// @dev Halts execution and returns the raw memory state.
    function __memoryDump() internal pure {
        assembly {
            return(0x00, msize())
        }
    }

    /// @dev Halts execution and returns the raw calldata.
    function __calldataDump() internal pure {
        assembly {
            let freeMemoryPointer := mload(0x40)
            calldatacopy(freeMemoryPointer, 0x00, calldatasize())
            return(freeMemoryPointer, calldatasize())
        }
    }

    /// @dev Halts execution and returns sequential storage slots.
    function __storageDump(uint256 start, uint256 end) internal view {
        assembly {
            let freeMemoryPointer := mload(0x40)
            for {
                let memoryPointer := freeMemoryPointer
                let storagePointer := start
            } lt(storagePointer, end) {
                memoryPointer := add(memoryPointer, 0x20)
                storagePointer := add(storagePointer, 0x01)
            } { mstore(memoryPointer, sload(storagePointer)) }
            return(freeMemoryPointer, mul(32, sub(end, start)))
        }
    }

    // WENNNNNNNNNNNNNN
    // function __transientDump(uint256 start, uint256 end) internal pure {
    //     assembly {
    //         let freeMemoryPointer := mload(0x40)
    //         for {
    //             let memoryPointer := freeMemoryPointer
    //             let storagePointer := start
    //         } lt(storagePointer, end) {
    //             memoryPointer := add(memoryPointer, 0x20)
    //             storagePointer := add(storagePointer, 0x01)
    //         } {
    //             mstore(memoryPointer, tload(storagePointer))
    //         }
    //         return(freeMemoryPointer, mul(32, sub(end, start)))
    //     }
    // }
}
