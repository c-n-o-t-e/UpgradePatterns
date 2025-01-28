// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counter} from "../src/Counter.sol";
import {Script, console} from "forge-std/Script.sol";
// import {console} from "forge-std/Test.sol";
import {CounterUpgrade} from "../src/CounterUpgrade.sol";
import "zeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BasicBeaconFactory} from "../src/Beacon/BasicBeaconFactory.sol";

contract CounterScript is Script {
    Counter public counter;
    CounterUpgrade public counterUpgrade;
    BasicBeaconFactory proxy;
    BasicBeaconFactory basicBeaconfactory;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        counter = new Counter();
        counterUpgrade = new CounterUpgrade();
        basicBeaconfactory = new BasicBeaconFactory();

        bytes memory init = abi.encodeCall(basicBeaconfactory.initialize, (address(counter)));
        ERC1967Proxy p = new ERC1967Proxy(address(basicBeaconfactory), init);
        proxy = BasicBeaconFactory(address(p));

        console.log("Counter address: ", address(counter), " Proxy address: ", address(proxy));
        console.log(
            "basicBeaconfactory address: ",
            address(basicBeaconfactory),
            "CounterUpgrade address: ",
            address(counterUpgrade)
        );

        vm.stopBroadcast();
    }
}
