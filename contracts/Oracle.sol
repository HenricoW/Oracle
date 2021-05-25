// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

contract Oracle {
    struct Data {
        uint256 timestamp;
        uint256 payload;
    }

    mapping(address => bool) public suppliers; // supplier => isSupplier
    mapping(bytes32 => Data) public records; // key => Data
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function editSupplier(address supplier, bool isSupplier) external {
        require(msg.sender == admin, "Only admin");
        suppliers[supplier] = isSupplier;
    }

    function storeData(bytes32 key, uint256 _payload) external {
        require(suppliers[msg.sender] == true, "Not approved supplier");
        records[key] = Data(block.timestamp, _payload);
    }

    function getData(bytes32 key)
        external
        view
        returns (
            bool success,
            uint256 timestamp,
            uint256 payload
        )
    {
        if (records[key].timestamp != 0) {
            return (false, 0, 0);
        }
        return (true, records[key].timestamp, records[key].payload);
    }
}
