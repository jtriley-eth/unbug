# Unbug

A Solidity calldata, memory, storage, and transient storage (soon:tm:) debugger.

## Intallation

```bash
forge install jtriley-eth/unbug
```

## Usgae

Import the `LibUnbug` library and `Unbug` abstract contract from the [entry point](src/Lib.sol)

```solidity
// -- snip --

import "lib/unbug/src/Lib.sol";

// -- snip --
```

Inherit `Unbug` into the contract to debug and inject one of the [functions](#api).

```solidity
// -- snip --

contract MyContract is Unbug {
    // -- snip --
    mapping(address => uint256) public balanceOf;

    function transfer(address receiver, uint256 amount) public {
        balanceOf[msg.sender] -= amount;
        balanceOf[reciever] += amount;
        // injects memory dump
        // NOTE: halts execution, everything after this is unreachable.
        __memoryDump();
    }
}
```

Interact with the contract via the `LibUnbug` library.

```solidity
// -- snip --

import "lib/forge-std/src/Test.sol";
import "lib/unbug/src/Lib.sol";

contract MyContractTest is Test {
    // use the library for the address for that juicy syntax
    using LibUnbug for address;

    address myContract;

    // -- snip --

    function testCheckMemoryInTransfer() public {
        // `memoryDump` wraps the call and extracts the 
        bytes memory memoryState = myContract.memoryDump(
            abi.encodeWithSignature("transfer(address, uint256)", (receiver, amount))
        );

        // `memoryState` is now treated as valid Solidity `bytes`
        console.logBytes(memoryState);
    }
}
```

## API

> NOTICE: The Yul Optimizer MUST be disabled to use this.


### [`Unbug`](src/Unbug.sol)

#### `__memoryDump()`

Halts execution and returns all of memory.

This overrides the return type specified by the function this is called in.

##### Signature

```solidity
function __memoryDump() internal pure;
```

#### `__calldataDump()`

Halts execution and returns all of calldata.

This overrides the return type specified by the function this is called in.

##### Signature

```solidity
function __calldataDump() internal pure;
```

#### `__storageDump(uint256,uint256)`

Halts execution and returns a range of storage values.

This overrides the return type specified by the function this is called in.

##### Arguments

- `start`: start of storage sequence
- `end`: end of storage sequence (exclusive)

##### Signature

```solidity
function __storageDump(uint256 start, uint256 end)
```

### [`LibUnbug`](src/LibUnbug.sol)

#### `memoryDump(address,bytes memory)`

Calls an `Unbug` child contract that contains a `__memoryDump`.

##### Arguments

- `target`: `Unbug` child contract
- `callData`: calldata that triggers the external function with the memory dump

##### Signature

```solidity
function memoryDump(address target, bytes memory callData) internal returns (bytes memory)
```

#### `calldataDump(address,bytes memory)`

Calls an `Unbug` child contract that contains a `__calldataDump`.

##### Arguments

- `target`: `Unbug` child contract
- `callData`: calldata that triggers the external function with the calldata dump

##### Signature

```solidity
function calldataDump(address target, bytes memory callData) internal returns (bytes memory)
```

#### `storaegDump(address,bytes memory)`

Calls an `Unbug` child contract that contains a `__storageDump`.

##### Arguments

- `target`: `Unbug` child contract
- `callData`: calldata that triggers the external function with the storage dump

##### Signature

```solidity
function storageDump(address target, bytes memory callData) internal returns (bytes memory)
```