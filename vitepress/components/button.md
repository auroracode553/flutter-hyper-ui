<script setup lang="ts">
import { buttonExample } from '../.vitepress/theme/examples';
</script>

# Button 按钮

按钮用于触发明确动作。当前提供填充、弱强调、描边、幽灵和危险五种视觉层级。

<DemoBlock
  title="基础状态"
  component="buttons"
  :code="buttonExample"
  :height="240"
/>

## API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `label` | 按钮文字 | `String` | 必填 |
| `onPressed` | 点击回调 | `VoidCallback?` | `null` |
| `variant` | 视觉层级 | `DocButtonVariant` | `filled` |
| `size` | 尺寸 | `DocButtonSize` | `md` |
| `icon` | 左侧图标 | `IconData?` | `null` |
| `trailingIcon` | 右侧图标 | `IconData?` | `null` |
| `loading` | 加载态 | `bool` | `false` |
| `expanded` | 是否撑满宽度 | `bool` | `false` |
