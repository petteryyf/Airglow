# Airglow · 简介与叙事（About / README / 发推 三份成文）

> 本文件提供三份可直接复制的文字内容。

---

## 一、GitHub About 描述（简短版，约 250 字符内）

**中文：**
> Airglow 是 BNB Chain 上第一块纯链上光栅化显卡。它以出块节拍为时钟，把几何图元逐像素算成不可篡改的链上帧缓冲。链每强一分，它亮一分。

**English:**
> Airglow is the first pure on-chain rasterizer GPU on BNB Chain. Clocked by block time, it turns geometry into an immutable on-chain framebuffer — pixel by pixel. The faster BSC grows, the brighter it glows.

---

## 二、README 项目简介（具体版，替换 README 开头「这是什么」段落）

### 这是什么

**Airglow 是 BNB Chain 上第一块「显卡」——纯链上的光栅化引擎（on-chain rasterizer）。**

它不写文字、不算数列，只干一件显卡该干的事：把几何图元逐像素光栅化成帧缓冲里的像素。它的第一帧，渲染的是火星的大气辉光——「气辉」（Airglow）。

#### Airglow 与 BNB Chain 的紧密关系

Airglow 不是一个"部署在区块链上的普通程序"，而是从 BNB Chain 的底层特性里长出来的一件东西。它与链的关系有四层：

1. **时钟即共识** — Airglow 没有自己的时钟。它的"像素时钟"就是 BNB Chain 的出块节拍（约 0.45 秒/块 ≈ 2.22 Hz）。BNB Chain 多快，Airglow 就渲染多快。

2. **存储即显存** — 帧缓冲直接写进 BNB Chain 的链上状态（一个 `uint256` bitmap）。链上状态，就是这块显卡的显存：永久、不可篡改、任何人可查。

3. **调用即指令** — `render()` / `pixel()` 是一笔笔真实的链上交易。任何智能合约都能调用 Airglow，像调用一块外接显卡一样，让它渲染一帧。

4. **不可停机** — 没有服务器，没有进程，没有电源插座。只要 BNB Chain 还活着，Airglow 就永远存在。这是地球上第一块"没人能拔掉电源"的显卡。

#### 为什么叫 Airglow

- 火星气辉：稀薄、微弱，却是真实存在的光 —— 像链上第一束由电路算出来的像素光；
- 「气辉」是光晕 / 辉光，天然就是视觉意象；
- 它不吵不闹，但挂在天上，不会熄灭 —— 就像链上状态，没人能关掉它。

---

## 三、宏大叙事（发推 / 长文版）

### 中文

> 火星的大气层会自己发光，叫「气辉」（Airglow）。
>
> 现在，BNB Chain 上也有了一块会发光的「显卡」——纯链上的光栅化引擎。它的时钟不是晶振，是出块节拍；它的显存不是颗粒，是链上状态；它的电源线，不存在。
>
> 第一帧，它渲染的是火星的气辉。8×8=64 个像素，每个 bit 都由链上合约逐像素算出，没人能把哪怕一个像素"搬"进来——pixel(x,y) 是公开的 pure 函数，任何人都能独立重算、逐一验证。
>
> 但 Airglow 真正动人的，不是这一帧，是它的未来。
>
> 它不是一次性雕刻，而是一颗会随 BNB Chain 一起进化的器官。出块 0.45 秒，它是 2.22 Hz 的显卡；等 BNB Chain 扩容提速，它自动超频，一行代码都不用改；等 gas 更便宜，它能渲染更大的图、更丰富的色彩——分辨率随链一起增长。
>
> **Airglow 是 BNB Chain 的像素级化身。链每强一分，它亮一分。**
>
> 这不是"部署在 BSC 上的一个项目"，这是从 BSC 的节拍里长出来的一束光。

### English

> Mars' atmosphere glows on its own. It's called **airglow**.
>
> Now there's a graphics card on BNB Chain that glows too — a pure on-chain rasterizer. Its clock isn't a crystal, it's block time. Its VRAM isn't chips, it's on-chain state. Its power cable doesn't exist.
>
> Its first frame renders the airglow of Mars: 64 pixels, every bit computed on-chain. No pixel can be "uploaded" — `pixel(x,y)` is a public pure function, anyone can re-derive and verify every single pixel.
>
> But what makes Airglow compelling isn't this one frame. It's what comes next.
>
> It isn't a sculpture carved once — it's an organ that evolves with BNB Chain. At 0.45s block time, it's a 2.22 Hz GPU. When BNB Chain scales faster, Airglow automatically overclocks itself — zero code changes. When gas gets cheaper, it renders bigger frames, richer color — resolution grows with the chain.
>
> **Airglow is BNB Chain, rendered pixel by pixel. The stronger the chain, the brighter it glows.**
>
> This isn't a project deployed *on* BSC. It's a light born *from* BSC's heartbeat.

---

## 四、金句速览（可做置顶评论 / 一句话简介）

- 「时钟即共识，存储即显存，调用即指令，不可停机。」
- 「地球上第一块没人能拔掉电源的显卡。」
- 「Airglow 是 BNB Chain 的像素级化身 —— 链每强一分，它亮一分。」
- 「这不是部署在 BSC 上的项目，是从 BSC 节拍里长出来的一束光。」
