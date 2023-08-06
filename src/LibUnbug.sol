// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Unbug Interaction Library
/// @author jtriley.eth
/// @dev Abstracts the low level call to contracts that inherit Unbug.
library LibUnbug {
    /// @dev Thrown when a call fails.
    error CallFailed();

    /// @dev Calls memory dump on a target contract.
    /// @param target Child of Unbug to call.
    /// @param callData Calldata to send to the target contract.
    function memoryDump(address target, bytes memory callData) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.call(callData);
        if (!success) revert CallFailed();
        return returndata;
    }

    /// @dev Calls calldata dump on a target contract.
    /// @param target Child of Unbug to call.
    /// @param callData Calldata to send to the target contract.
    function calldataDump(address target, bytes memory callData) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.call(callData);
        if (!success) revert CallFailed();
        return returndata;
    }

    /// @dev Calls storage dump on a target contract.
    /// @param target Child of Unbug to call.
    /// @param callData Calldata to send to the target contract.
    function storageDump(address target, bytes memory callData) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.call(callData);
        if (!success) revert CallFailed();
        return returndata;
    }
}
