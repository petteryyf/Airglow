// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Airglow} from "../src/Airglow.sol";

contract AirglowTest is Test {
    Airglow internal airglow;

    function setUp() public {
        airglow = new Airglow();
    }

    // 渲染出的帧缓冲，与本地 Python 光栅化内核逐像素一致
    function test_mars_airglow_bitmaps() public {
        uint256 frame = airglow.render();

        // 火星本体（橙红）
        assertEq(airglow.core(), 0x00003c24243c0000, "core bitmap mismatch");
        // 气辉光晕（冷青）
        assertEq(airglow.glow(), 0x003c424242423c00, "glow bitmap mismatch");
        // 完整帧 = core | glow
        assertEq(frame, 0x00003c24243c0000 | 0x003c424242423c00, "frame mismatch");
        assertEq(airglow.frame(), frame, "stored frame mismatch");
        assertTrue(airglow.rendered(), "rendered flag not set");
    }

    // 单像素可独立验证：pixel() 是 pure 函数，任何人可重算
    function test_pixel_independent_verify() public view {
        // 中心 (3.5,3.5) 附近 —— 火星本体
        assertEq(airglow.pixel(3, 3), 1, "(3,3) should be core");
        assertEq(airglow.pixel(4, 4), 1, "(4,4) should be core");
        // 外圈 —— 气辉
        assertEq(airglow.pixel(0, 3), 0, "(0,3) is space");
        assertEq(airglow.pixel(3, 0), 0, "(3,0) is space");
    }

    // 越界必须回退
    function test_pixel_out_of_range_reverts() public {
        vm.expectRevert("out of range");
        airglow.pixel(8, 0);
    }
}
