<script setup lang="ts">
import { cardExample } from '../.vitepress/theme/examples';
</script>

# Card 卡片

卡片用于承载内容摘要、操作入口和轻量状态信息。默认无阴影，使用细边框建立层次。

<DemoBlock
  title="基础卡片"
  component="cards"
  :code="cardExample"
  :height="300"
/>

## API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `title` | 标题 | `String?` | `null` |
| `subtitle` | 副标题 | `String?` | `null` |
| `leading` | 头部左侧内容 | `Widget?` | `null` |
| `actions` | 头部右侧操作 | `List<Widget>` | `[]` |
| `footer` | 底部区域 | `Widget?` | `null` |
| `child` | 主内容 | `Widget?` | `null` |
| `onTap` | 点击回调 | `VoidCallback?` | `null` |
| `selected` | 选中态 | `bool` | `false` |
