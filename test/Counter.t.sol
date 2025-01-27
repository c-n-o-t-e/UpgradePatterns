// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counter} from "../src/Counter.sol";
import {Test, console} from "forge-std/Test.sol";
import {CounterUpgrade} from "../src/CounterUpgrade.sol";
import "zeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BasicBeaconFactory} from "../src/Beacon/BasicBeaconFactory.sol";

contract CounterTest is Test {
    Counter counter;
    BasicBeaconFactory proxy;
    BasicBeaconFactory basicBeaconfactory;

    function setUp() public {
        counter = new Counter();
        basicBeaconfactory = new BasicBeaconFactory();

        bytes memory init = abi.encodeCall(basicBeaconfactory.initialize, (address(counter)));
        ERC1967Proxy p = new ERC1967Proxy(address(basicBeaconfactory), init);
        proxy = BasicBeaconFactory(address(p));
    }

    function test_deployProxy() public {
        CounterUpgrade counterUpgrade = new CounterUpgrade();

        Counter counter0 = Counter(address(proxy.createBeaconProxy("")));
        Counter counter1 = Counter(address(proxy.createBeaconProxy("")));

        counter0.increment();
        counter1.increment();
        counter1.increment();

        console.log("Counter number: ", counter.number());
        console.log("Counter number: ", counter0.number());
        console.log("Counter number: ", counter1.number());

        vm.expectRevert();
        CounterUpgrade(address(counter0)).decrement();

        vm.prank(address(proxy));
        proxy.counterBeacon().upgradeTo(address(counterUpgrade));

        CounterUpgrade(address(counter0)).decrement();
        CounterUpgrade(address(counter1)).decrement();

        console.log("Counter number: ", counter0.number());
        console.log("Counter number: ", counter1.number());
    }
}
