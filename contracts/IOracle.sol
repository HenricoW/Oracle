// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

interface IOracle {
    function getData(bytes32 key)
        external
        view
        returns (
            bool success,
            uint256 timestamp,
            uint256 payload
        );
}
