---
title: HyNavBarPage
description: 内容可滚入透明导航栏与状态栏区域的全面屏布局
---

<ComponentDoc component-id="nav-bar-page" />

## 布局约定

放在 `Scaffold.body` 中，以 `slivers` 提供正文。页面用同一个覆盖完整区域的滚动视口承载首屏顶部留白与正文，透明 `navBar` 固定叠在顶部。首次显示时正文在状态栏和导航栏之后；向上滚动时留白自然移出屏幕，正文可以经过导航栏进入状态栏区域。

不要在外层包顶部 `SafeArea` 或另外设置 `appBar`。`navBar.safeArea` 默认开启，只避让导航操作区；正文不会受到顶部安全区裁剪。底部安全区留白追加在内容末尾，不缩小滚动视口。

`controller` 由调用方管理和释放，可以用于回到顶部。`systemOverlayStyle` 可按页面内容对比度调整系统图标；组件默认请求透明状态栏，真实设备能否覆盖系统区域由宿主应用的平台 edge-to-edge 配置决定。文档示例直接使用外层手机屏幕及其安全区，不再绘制额外的设备框和模拟状态栏。

完整用法和旧 API 迁移说明见 [HyNavBar](./nav-bar)。
