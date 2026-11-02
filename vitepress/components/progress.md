---
title: HyperProgress
description: HyperProgress 组件与公开 API
---

<ComponentDoc component-id="progress" />

线性进度从文字方向的起始侧填充，数值变化使用短过渡。减少动画设置启用时立即更新；未知进度保留可见的静止片段。value 为 null、NaN 或无穷值时使用不定进度，有限越界值收敛到 0–1。百分比向下取整，避免四舍五入导致提前显示 100%。

## 固定玻璃与动效

轨道使用 Track 固定玻璃（2 逻辑像素 模糊、2/3 逻辑像素 折射、无外阴影），默认轨道色 alpha ×0.65；填充叠加静态柔和光泽，不添加循环扫光。线性与圆环确定值共用 stiffness=1000、dampingRatio=1、阈值 0.001 的临界阻尼弹簧。圆环只绘制空心轨道，不增加圆盘底板；百分比仍反映受控目标值。
