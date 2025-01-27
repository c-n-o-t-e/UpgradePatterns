// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BeaconProxy} from "zeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "zeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract BasicBeaconFactory is UpgradeableBeacon {
    constructor(address _implementation) UpgradeableBeacon(_implementation, msg.sender) {}

    function createBeaconProxy(bytes memory _data) public returns (BeaconProxy) {
        BeaconProxy beaconProxy = new BeaconProxy(address(this), _data);
        return beaconProxy;
    }
}
