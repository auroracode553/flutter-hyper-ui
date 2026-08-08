<script setup lang="ts">
import { inputExample } from '../.vitepress/theme/examples';
</script>

# Input 输入

输入组件包含 `DocTextField` 与 `DocSegmentedControl`。前者用于文本输入，后者用于少量互斥选项。

<DemoBlock
  title="筛选表单"
  component="inputs"
  :code="inputExample"
  :height="360"
/>

## DocTextField API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `label` | 标签 | `String?` | `null` |
| `hintText` | 占位文字 | `String?` | `null` |
| `helperText` | 辅助文字 | `String?` | `null` |
| `errorText` | 错误文字 | `String?` | `null` |
| `prefixIcon` | 前置图标 | `IconData?` | `null` |
| `maxLines` | 最大行数 | `int` | `1` |

## DocSegmentedControl API

| 属性 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| `options` | 选项列表 | `List<DocSegmentOption<T>>` | 必填 |
| `selectedValue` | 当前值 | `T` | 必填 |
| `onChanged` | 切换回调 | `ValueChanged<T>` | 必填 |
| `equalWidth` | 选项是否等宽 | `bool` | `true` |
