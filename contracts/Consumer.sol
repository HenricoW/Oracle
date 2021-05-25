// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./IOracle.sol";

contract Consumer {
    uint256 public payload;
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function fetchData(string calldata keyString) external {
        bytes32 key = keccak256(abi.encodePacked(keyString));
        (bool status, uint256 timestamp, uint256 _payload) =
            oracle.getData(key);
        require(status, "Data not available");
        require(timestamp >= block.timestamp - 2 weeks, "Data too old");
        payload = _payload;
    }
}
