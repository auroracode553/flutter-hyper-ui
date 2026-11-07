---
title: HyperDrawer
description: HyperDrawer 组件与公开 API
---

<ComponentDoc component-id="drawer" />

## HyperDrawerPlacement

| 值 | 作用 |
| --- | --- |
| start | 默认；LTR 从左侧展开，RTL 从右侧展开 |
| end | LTR 从右侧展开，RTL 从左侧展开 |

## 默认布局与交互

抽屉是贴边、全高的模态面板，默认从 start 侧展开，RTL 自动镜像。使用固定模糊玻璃背景，面板外侧没有留白、圆角、描边或卡片阴影；系统安全区和键盘避让位于背景内部。

width 默认 320，最大为窗口宽度减 56，保留遮罩点击区。contentPadding 默认零，只影响正文；正文自行提供 ListView 时设置 scrollable: false。title 与 footerBuilder 提供固定标题和页脚。

顶部由抽屉内部的 HyperSafeArea（edge: HyperSafeAreaEdge.top）统一保护标题、关闭按钮和正文；调用方不需要再包顶部安全区或写固定挖孔高度。背景仍铺满窗口，底部、横向系统区与键盘避让保持在背景内部。contentBuilder 与 footerBuilder 收到已消费顶部安全区的上下文，内部同侧嵌套不会重复留白。

正文零额外间距不代表列表行零内边距：抽屉内的 HyperListTile 保留左右各 14 的行内留白，选中底色和尾部图标也遵守同一规则。其他自定义内容仍由 contentPadding 或自身布局决定，不给整个抽屉额外套一层水平 Padding。

面板在 280ms 内从自身宽度之外平移进入，遮罩单独淡入。向外滑动超过宽度 30% 或释放速度达到 400 逻辑像素／秒时关闭；未达到阈值则在 180ms 内回到展开位置。遮罩、返回键和滑动分别由 dismissOnClickOutside、dismissOnBackPress、gesturesEnabled 控制。

show 返回的 Future 在退出动画结束后完成，便于继续导航或恢复底层原生视图。

```dart
final result = await HyperDrawer.show<String>(
  context,
  title: '导航',
  contentBuilder: (drawerContext) => HyperListTile(
    title: '首页',
    onPressed: () => Navigator.pop(drawerContext, 'home'),
  ),
);
```

## 固定玻璃与动效

背景使用 Drawer 固定玻璃，浅/深色模糊 16/8 逻辑像素、白色底面 alpha 0.85/0.28；不增加透镜边缘、轮廓或阴影。宽度、全高、系统安全区、正文滚动、滑动阈值和退出流程保持原规则。

根路由/Overlay 显式继承发起位置 HyperBackdrop 的独立背景源，只采样背景，不录制面板自身。背景宿主先销毁时回退材质底面，浮层不接管或重复释放录制器。
