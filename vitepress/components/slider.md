---
title: HyperSlider
description: HyperSlider 组件与公开 API
---

<ComponentDoc component-id="slider" />

## 材质与交互

保留 44 的触摸高度、6 的轨道高度和 20 的圆形玻璃滑块，默认无品牌描边；按下时白色底面逐渐透明，背景和轨道单独录制；模糊由 8 变为 0，折射边缘/位移为 10/14，带七波段色散和高光，松开恢复。点击或外部值更新使用临界阻尼弹簧（mass 1、stiffness 1000、damping 63.2455532），拖动直接跟手，不改变滑块尺寸。只读和禁用不响应按压高光；禁用手柄使用 muted 底色。

保持 min/max/divisions 和开始／变化／结束回调时机；取消拖动只复原按压视觉，不增加业务回调。RTL 反转轨道方向；减少动态效果时直接定位。Flutter 仅使用引擎背景模糊与高光，不执行 Compose 原生折射着色器。
