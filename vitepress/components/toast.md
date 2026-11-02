---
title: HyperToast
description: HyperToast 组件与公开 API
---

<ComponentDoc component-id="toast" />

## 固定玻璃与动效

提示表面使用 Panel 固定玻璃（8 逻辑像素 模糊、12/18 逻辑像素 折射、8 逻辑像素 阴影）。125ms、0.97→1 缩放淡入，关闭时反向退出后才停止绘制；计时从显示开始，duration=Duration.zero 不自动关闭。语义色仅合成底面和现有边界，文字图标保持清晰。

根路由/Overlay 显式继承发起位置 HyperBackdrop 的独立背景源，只采样背景，不录制面板自身。背景宿主先销毁时回退材质底面，浮层不接管或重复释放录制器。
