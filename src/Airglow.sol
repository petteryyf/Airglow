// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * Airglow — 链上第一块「显卡」
 * 火星的气辉：大气层自身发出的微弱光芒。
 *
 * 这是一块纯链上的光栅化引擎（on-chain rasterizer）。
 * 它不绕门电路、不需要通用 CPU —— 就像真实的显卡那样，
 * 直接把几何图元逐像素算成帧缓冲里的像素。
 *
 * 第一帧：火星的气辉（Mars Airglow）
 *   8×8 = 64 像素，1 bit = 1 像素，帧缓冲用 uint256 承载。
 *   每个像素是否点亮，由光栅化内核逐像素判定：
 *   判断 (x,y) 是否落在「带光晕的星体」几何图元内。
 *
 * 分层光栅化：
 *   core = 火星本体（实心圆）  —— 橙红
 *   glow = 气辉光晕（环形带）  —— 冷青
 *   深空 = 背景                —— 近黑
 */

contract Airglow {
    // ---- 帧缓冲（链上「显存」） ----
    // 两个 uint256 各存 64 bit 像素面，bit index = y*8 + x（左上角 LSB）
    uint256 public core;      // 火星本体
    uint256 public glow;      // 气辉光晕
    uint256 public frame;     // 完整帧 = core | glow

    // ---- 渲染参数（8×8 网格，中心以整数坐标表示） ----
    uint8 public constant WIDTH = 8;
    uint8 public constant HEIGHT = 8;

    // 已渲染标记
    bool public rendered;
    uint256 public renderedAt;

    event Pixel(uint8 x, uint8 y, uint8 layer); // 每画一个像素发一个事件（可选，日志即「扫描过程」）
    event Rendered(uint256 core, uint256 glow, uint256 frame);

    /*
     * 光栅化内核：判定 (x,y) 像素落在哪一层。
     * 中心取 (3.5, 3.5)，为避免小数，所有距离平方用整数坐标偏移 + 8 倍缩放表示。
     * 令 cx=7, cy=7（即 3.5*2），dx = 2x-7, dy = 2y-7（偶数可整除），
     * d2_scaled = dx^2 + dy^2（已 *4）。 比较时用「半径^2 * 4」。
     */
    function _layer(uint8 x, uint8 y) internal pure returns (uint8) {
        int256 dx = int256(uint256(x)) * 2 - 7;
        int256 dy = int256(uint256(y)) * 2 - 7;
        int256 d2 = dx * dx + dy * dy; // = 4 * 真实距离^2

        // 火星本体：一个实心圆。半径取 3.0（真实），=> r^2 *4 = 36
        if (d2 <= 36) return 1; // core
        // 气辉光晕：环形带，半径 (3.0, 4.0)，=> 36 < d2 <= 64
        if (d2 <= 64) return 2; // glow
        return 0; // space
    }

    /*
     * 渲染：逐像素执行光栅化内核，把结果写进帧缓冲。
     * 每个像素的 bit 位置 = y * 8 + x。
     */
    function render() public returns (uint256 frameOut) {
        uint256 c = 0;
        uint256 g = 0;
        for (uint8 y = 0; y < HEIGHT; y++) {
            for (uint8 x = 0; x < WIDTH; x++) {
                uint8 layer = _layer(x, y);
                if (layer == 1) {
                    c |= (uint256(1) << (y * WIDTH + x));
                } else if (layer == 2) {
                    g |= (uint256(1) << (y * WIDTH + x));
                }
                emit Pixel(x, y, layer);
            }
        }
        core = c;
        glow = g;
        frame = c | g;
        rendered = true;
        renderedAt = block.timestamp;
        emit Rendered(c, g, frame);
        return frame;
    }

    /*
     * 查询单像素：链上向「显卡」问「这个点是什么颜色层」。
     * 等同光栅化内核的单点求值 —— 任何合约/前端都能独立验证像素值，
     * 证明「每一个像素都是算出来的，不是谁塞进去的」。
     */
    function pixel(uint8 x, uint8 y) external pure returns (uint8 layer) {
        require(x < WIDTH && y < HEIGHT, "out of range");
        return _layer(x, y);
    }
}
