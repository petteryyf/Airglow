// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Airglow} from "../src/Airglow.sol";
import {console} from "forge-std/console.sol";

contract DeployAirglow is Script {
    function run() public returns (Airglow) {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        Airglow airglow = new Airglow();

        // 部署后立即渲染第一帧：火星的气辉
        uint256 frame = airglow.render();

        vm.stopBroadcast();

        console.log("Airglow deployed at:", address(airglow));
        console.log("core : 0x%016x", airglow.core());
        console.log("glow : 0x%016x", airglow.glow());
        console.log("frame: 0x%016x", frame);

        return airglow;
    }
}
