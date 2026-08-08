<script setup lang="ts">
import { dataExample } from '../.vitepress/theme/examples';
</script>

# Data 数据展示

数据展示组件用于列表、状态徽标和线性进度。

<DemoBlock
  title="列表与进度"
  component="data"
  :code="dataExample"
  :height="340"
/>

## 组件

| 组件 | 说明 |
| --- | --- |
| `DocBadge` | 小型语义徽标 |
| `DocTag` | 可选中标签 |
| `DocListTile` | 可点击列表项 |
| `DocProgressBar` | 线性进度条 |
