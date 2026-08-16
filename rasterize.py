# -*- coding: utf-8 -*-
"""
Airglow · 链上光栅化引擎 —— 帧缓冲 + 光栅化内核 + 可视化

第一帧：火星的气辉（Airglow of Mars）

设计：8×8 = 64 像素，1 像素 = 1 bit，帧缓冲用一个 uint256 承载。
     每个像素是否点亮，由「光栅化内核」逐像素判定 —— 这是光栅化的本质：
     判断 (x,y) 是否落在几何图元（这里是一个「带光晕的星体」）内。

光晕（气辉）用「多层同心圆」表达：核心实心圆 + 外围一圈稀薄光晕。
这正好隐喻「气辉」—— 星体边缘那层微弱的光。
"""
from __future__ import annotations

W = H = 8


def radial(layer: int, x: int, y: int) -> bool:
    """第 layer 层圆：中心 (3.5,3.5)，半径逐层递增。
    返回该像素是否属于这一层（环形带）。
    """
    cx = cy = 3.5
    d2 = (x - cx) ** 2 + (y - cy) ** 2
    r_inner = layer - 0.5
    r_outer = layer + 0.5
    return r_inner ** 2 <= d2 <= r_outer ** 2


def rasterize_mars_airglow(x: int, y: int) -> int:
    """Airglow 光栅化内核：判定 (x,y) 像素的亮度等级。

    返回 0（暗/太空）、1（核心火星球体）、2（气辉光晕）。
    """
    # 底层核心：火星本体（一个实心圆）
    if radial(2, x, y):
        return 1
    # 外围气辉：稀薄光晕（一层）
    if radial(3, x, y):
        return 2
    return 0


def render() -> tuple[int, int]:
    """逐像素跑光栅化内核，得到两件事：
    - core  : uint256 —— 火星球体的帧缓冲（bitmap）
    - glow  : uint256 —— 气辉光晕的帧缓冲（bitmap）

    bit 序：左上角 (0,0) 为 LSB，index = y*W + x
    """
    core = glow = 0
    for y in range(H):
        for x in range(W):
            v = rasterize_mars_airglow(x, y)
            idx = y * W + x
            if v == 1:
                core |= (1 << idx)
            elif v == 2:
                glow |= (1 << idx)
    return core, glow


# ---------- 可视化（只做展示，不参与像素判定） ----------

PALETTE = {
    0: "·",          # 太空
    1: "██",         # 火星本体（橙色系往深里走，用占位符）
    2: "░░",         # 气辉（稀薄光晕）
}


def show(core: int, glow: int) -> str:
    rows = []
    for y in range(H):
        line = ""
        for x in range(W):
            idx = y * W + x
            if (core >> idx) & 1:
                line += PALETTE[1]
            elif (glow >> idx) & 1:
                line += PALETTE[2]
            else:
                line += PALETTE[0]
        rows.append(line)
    return "\n".join(rows)


def to_svg(core: int, glow: int, cell: int = 64) -> str:
    """导出 SVG：火星本体橙红、气辉冷青色光晕、太空深空色。"""
    color_core = "#E8613C"   # 火星橙红
    color_glow = "#6BD8E0"   # 气辉冷青
    color_space = "#0B0D12"  # 深空
    size = W * cell
    rects = []
    for y in range(H):
        for x in range(W):
            idx = y * W + x
            if (core >> idx) & 1:
                fill = color_core
            elif (glow >> idx) & 1:
                fill = color_glow
            else:
                fill = color_space
            rects.append(
                f'<rect x="{x*cell}" y="{y*cell}" width="{cell}" height="{cell}" '
                f'rx="6" fill="{fill}"/>'
            )
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}" '
        f'viewBox="0 0 {size} {size}">'
        f'<rect width="{size}" height="{size}" fill="{color_space}"/>'
        + "".join(rects) +
        "</svg>"
    )


if __name__ == "__main__":
    core, glow = render()
    print("=== Airglow · 火星的气辉 ===")
    print(f"core bitmap = 0x{core:016x}")
    print(f"glow bitmap = 0x{glow:016x}")
    print()
    print(show(core, glow))
    print()
    path = "/home/lighthouse/.openclaw/workspace/airglow/airglow.svg"
    with open(path, "w") as f:
        f.write(to_svg(core, glow))
    print(f"[saved] {path}")
