# Airglow · 发推文案

> 中英双语，直接可用。建议配图：`airglow.png`（火星气辉渲染图）+ 合约地址截图。

---

## 主推文案（中文）

火星的大气层会自己发光，叫「气辉」（Airglow）。

现在，BNB Chain 上也有了一块会发光的「显卡」。

它是一块**纯链上的光栅化引擎**——没有复用任何通用 CPU，不绕门电路，就像真正的 GPU 那样，把几何图元直接逐像素算成帧缓冲。

第一帧，它渲染的正是**火星的气辉**：

8×8 = 64 个像素，每一个 bit 都由链上合约的光栅化内核逐像素算出。中间橙红是火星本体，外圈冷青是稀薄的气辉。

没有一个像素是被「搬」进链上的——`pixel(x,y)` 是公开的 pure 函数，任何人都能独立重算、逐个验证。

这是「渲染」这个词，第一次在区块链上有了真实的、不可篡改的含义。

CPU 有 Behemoth，显卡有 Airglow。
计算机史从「通用 CPU」到「专用 GPU」的那次分叉，正在链上重演。

帧缓冲：
core = 0x00003c24243c0000
glow = 0x003c424242423c00

---

## 主推文案（English）

Mars' atmosphere glows on its own. It's called **airglow**.

Now there's a graphics card on BNB Chain that glows too.

It's a **pure on-chain rasterizer** — no general-purpose CPU underneath, no gate-circuit trickery. Like a real GPU, it turns geometric primitives into framebuffer pixels, directly and per-pixel.

Its first frame renders **the airglow of Mars**:

8×8 = 64 pixels. Every single bit is computed on-chain by the rasterization kernel — Mars' body in red-orange at the center, its faint airglow in cyan around it.

No pixel was "uploaded" into the chain. `pixel(x,y)` is a public pure function — anyone can re-derive and verify every pixel, independently.

This is the first time the word "rendering" has a real, immutable meaning on-chain.

CPU: Behemoth. GPU: Airglow.
The fork in computing history — from general-purpose CPU to dedicated GPU — is now replaying, on-chain.

Framebuffer:
core = 0x00003c24243c0000
glow = 0x003c424242423c00

---

## 短推 / 评论区置顶（一句版）

> 火星有气辉，链上有第一块显卡。Airglow 在 BNB Chain 上光栅化了历史上第一帧链上渲染图。🚀 from airglow to Mars.

---

## 发推 Checklist

- [ ] 配图：`airglow.png`
- [ ] Tag `@BNBCHAIN`（呼应 Behemoth 那次的 @）
- [ ] 附合约地址（部署后）
- [ ] 置顶短句评论
- [ ] 中英双语两条分别发（英文搞大圈，中文搞国内）
