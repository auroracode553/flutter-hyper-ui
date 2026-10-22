---
title: HyperCollapse
description: HyperCollapse 组件与公开 API
---

<ComponentDoc component-id="collapse" />

折叠面板与 HyperCard、HyperMenuGroup、独立 HyperListTile 共用内部卡片表面：普通状态无描边，采用主题底色与双层柔阴影，高对比模式保留识别边界。圆角、内边距、标题和折叠交互沿用组件原有规则。

## 交互动画

内容高度与透明度在 200ms 内同步变化，箭头随开合旋转。快速再次点击时从当前高度反向；首次展开后保留内容内部状态，收起后暂停内部动画并停止接受操作。系统启用“减少动态效果”时直接切换展开状态。
