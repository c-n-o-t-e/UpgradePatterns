// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract BasicBeacon is UpgradeableBeacon {
    constructor(address _implementation) UpgradeableBeacon(_implementation, msg.sender) {}

    function createBeaconProxy(bytes memory _data) public returns (BeaconProxy) {
        BeaconProxy beaconProxy = new BeaconProxy(address(this), _data);
        return beaconProxy;
    }
}
