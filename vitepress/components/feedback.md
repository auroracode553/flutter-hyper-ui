<script setup lang="ts">
import { feedbackExample } from '../.vitepress/theme/examples';
</script>

# Feedback 反馈

反馈组件用于空状态、语义状态和轻量提示。

<DemoBlock
  title="空状态"
  component="feedback"
  :code="feedbackExample"
  :height="380"
/>

## HyEmptyState API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `icon` | 状态图标 | `IconData` | 必填 |
| `title` | 标题 | `String` | 必填 |
| `message` | 辅助说明 | `String?` | `null` |
| `action` | 操作按钮 | `Widget?` | `null` |
