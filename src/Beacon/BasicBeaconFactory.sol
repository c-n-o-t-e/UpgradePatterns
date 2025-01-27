// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "open/contracts/proxy/utils/Initializable.sol";
import {BeaconProxy} from "zeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "zeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract BasicBeaconFactory is Initializable {
    UpgradeableBeacon public counterBeacon;

    constructor() {
        _disableInitializers();
    }

    function initialize(address _implementation) public initializer {
        counterBeacon = new UpgradeableBeacon(_implementation, msg.sender);
    }

    function createBeaconProxy(bytes memory _data) public returns (BeaconProxy) {
        BeaconProxy beaconProxy = new BeaconProxy(address(counterBeacon), _data);
        return beaconProxy;
    }
}
