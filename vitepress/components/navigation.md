<script setup lang="ts">
import { navigationExample } from '../.vitepress/theme/examples';
</script>

# Navigation 导航

导航组件提供顶部栏和可点击列表项，适合工具型页面的紧凑布局。

<DemoBlock
  title="顶部栏"
  component="navigation"
  :code="navigationExample"
  :height="360"
/>

## DocTopBar API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `title` | 标题 | `String` | 必填 |
| `subtitle` | 副标题 | `String?` | `null` |
| `leading` | 左侧区域 | `Widget?` | `null` |
| `actions` | 右侧操作 | `List<Widget>` | `[]` |
| `safeArea` | 是否包含顶部安全区 | `bool` | `true` |
