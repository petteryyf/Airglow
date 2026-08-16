# Airglow 🌌

> 火星的大气层自身会发出微弱的光，这种现象叫 **气辉（Airglow）**。
> 现在，BNB Chain 上也有了一块会发光的「显卡」——它把「渲染」第一次带到了链上。

**Airglow 是一块纯链上的光栅化引擎（an on-chain rasterizer）。**
它用区块链的出块节拍做时钟，逐像素执行光栅化算法，把几何图元变成帧缓冲里的像素。

![Airglow · 火星的气辉](airglow.png)

---

## 目录

- [这是什么](#这是什么)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [链上渲染原理](#链上渲染原理)
- [合约接口](#合约接口)
- [部署到 BNB Chain](#部署到-bnb-chain)
- [License](#license)

---

## 这是什么

| | Behemoth（姊妹项目） | **Airglow（本项目）** |
|---|---|---|
| 角色 | CPU · 通用计算 | **显卡 / 光栅化引擎** |
| 历史对标 | Intel 4004 (1971) | 专用图形芯片 / GPU 光栅化 |
| 干什么 | 取指-译码-执行，跑斐波那契 | 几何图元 → 像素帧缓冲 |
| 时钟 | 出块节拍 ≈ 2.22 Hz | 出块节拍 ≈ 2.22 Hz |

计算机史上，显卡是从 CPU 里独立出来的专用芯片。
Behemoth 是「通用 CPU」，Airglow 是「专用 GPU」——两条线正好复刻了这段历史的分叉。

### 为什么叫 Airglow

- 火星气辉：稀薄、微弱，却是真实存在的光 —— 像链上第一束由电路算出来的像素光；
- 「气辉」是光晕 / 辉光，天然就是视觉意象；
- 它不吵不闹，但挂在天上，不会熄灭 —— 就像链上状态，没人能关掉它。

---

## 快速开始

> 不写合约、不装任何 Web3 依赖，也能立刻复现第一帧。

### 方式一：本地渲染（零依赖，推荐先玩这个）

只需 Python 3：

```bash
make render
# 或
python3 rasterize.py
```

会输出第一帧「火星的气辉」的点阵，并生成 `airglow.png` / `airglow.svg`：

```
········
··░░░░░░░░··
·░░████████░░·
·░░██··██░░·
·░░██··██░░·
·░░████████░░·
··░░░░░░░░··
········
```

> `██` = 火星本体，`░░` = 气辉光晕，`·` = 深空。

### 方式二：合约测试（需要 Foundry）

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup

forge test -vv
```

四条测试全部通过即证明：**链上合约渲染出的帧缓冲，与本地 Python 光栅化内核逐像素一致。**

---

## 项目结构

```
airglow/
├── src/
│   └── Airglow.sol           # 纯链上光栅化合约（核心）
├── test/
│   └── Airglow.t.sol         # Foundry 单测
├── script/
│   └── DeployAirglow.s.sol   # 部署脚本（部署即渲染第一帧）
├── rasterize.py              # 本地光栅化内核 + 可视化（零依赖）
├── foundry.toml              # Foundry 配置
├── Makefile                  # 一键命令（render / test / deploy）
├── .env.example              # 环境变量模板
├── POST.md                   # 中英双语文案
└── airglow.png / .svg        # 第一帧渲染图
```

---

## 链上渲染原理

### 光栅化（Rasterization）

GPU 的灵魂不是「快」，是 **光栅化**：把几何图元（点、线、圆、三角形）转成像素格。
这一步天生是**逐像素、逐坐标、确定性**的 —— 完美契合链上串行出块的特性。

链上做不了几千核并行，但能 100% 真的做「光栅化」。

### 渲染流程

1. **几何图元**：输入一个数学描述（这里是「带光晕的星体」）
2. **光栅化内核**：逐像素判定「这个 (x,y) 落在图元哪一层？」
   - `d² ≤ 36` → 火星本体（core）
   - `36 < d² ≤ 64` → 气辉光晕（glow）
   - 其余 → 深空
3. **帧缓冲**：结果写进两个 `uint256`，每一 bit 就是一个像素
4. **输出**：链下只负责把 bit 显示成颜色，**绝不参与像素判定**

### 第一帧：火星的气辉

```
core = 0x00003c24243c0000   # 火星本体（橙红）
glow = 0x003c424242423c00   # 气辉光晕（冷青）
frame = core | glow         # 完整帧
```

> 8×8 = 64 像素，1 bit = 1 像素，bit index = `y * 8 + x`（左上角 LSB）。

---

## 合约接口

```solidity
contract Airglow {
    uint256 public core;       // 火星本体帧缓冲
    uint256 public glow;       // 气辉光晕帧缓冲
    uint256 public frame;      // 完整帧 = core | glow
    bool    public rendered;   // 是否已渲染
    uint256 public renderedAt; // 渲染时间戳

    function render()                       // 逐像素渲染，写进帧缓冲
    function pixel(uint8 x, uint8 y)       // 独立验证单像素（pure）
}
```

**关键点**：`pixel(x,y)` 是公开的 `pure` 函数 —— 任何合约、任何前端都能独立重算每个像素，
证明「图是算出来的，不是谁塞进链上的数据」。这是「链上渲染」最硬的自证。

---

## 部署到 BNB Chain

```bash
# 1. 配置环境变量
cp .env.example .env
# 编辑 .env，填入 PRIVATE_KEY 和 BSC_RPC_URL

# 2. 部署（部署成功即自动渲染第一帧）
make deploy
```

部署脚本会打印合约地址和三个帧缓冲 bitmap。

---

## 发推文案

见 [`POST.md`](POST.md)。

---

## License

[MIT](LICENSE)
