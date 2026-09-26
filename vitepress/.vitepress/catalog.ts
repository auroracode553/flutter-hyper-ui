export interface ComponentPropDoc {
  name: string;
  description: string;
}

export interface ComponentEntry {
  id: string;
  name: string;
  navName: string;
  page: string;
  source: string;
  summary: string;
  preview?: ComponentDemo;
  sidebar?: boolean;
  propsDocs?: ComponentPropDoc[];
}

export interface ComponentDemo {
  id: string;
  title: string;
  description?: string;
  height: number;
  source: string;
  symbol?: string;
}

export interface ComponentGroup {
  id: string;
  title: string;
  navTitle: string;
  description: string;
  page: string;
  demos: ComponentDemo[];
  components: ComponentEntry[];
  conventions?: string[];
}

interface ComponentOptions {
  id?: string;
  navName?: string;
  preview?: ComponentDemo;
  sidebar?: boolean;
  propsDocs?: ComponentPropDoc[];
}

function componentId(name: string) {
  return name
    .replace(/^Hy/, '')
    .replace(/([a-z0-9])([A-Z])/g, '$1-$2')
    .toLowerCase();
}

const component = (
  name: string,
  source: string,
  summary: string,
  options: ComponentOptions = {},
): ComponentEntry => {
  const navName = options.navName ?? name.split('/')[0].trim().replace(/<.*>/, '');
  const id = options.id ?? componentId(navName);
  return {
    id,
    name,
    navName,
    page: `/components/${id}`,
    source,
    summary,
    preview: options.preview,
    sidebar: options.sidebar ?? true,
    propsDocs: options.propsDocs,
  };
};

const demo = (
  id: string,
  title: string,
  source: string,
  height: number,
  description?: string,
  symbol?: string,
): ComponentDemo => ({ id, title, source, height, description, symbol });

export const featuredDemo = demo(
  'glass-library',
  '柔性玻璃组件总览',
  'glass_library_example.dart',
  980,
  '导航、输入、菜单、反馈与加载组件的统一状态和交互。',
);

/**
 * 文档的唯一人工维护目录。
 *
 * 页面、侧栏和演示均读取这里；组件 source 必须指向真实 Dart 源文件，
 * Demo id 必须存在于 PreviewCatalog，Demo source 必须指向真实示例文件。
 */
export const componentGroups: ComponentGroup[] = [
  {
    id: 'foundations',
    title: '基础组件',
    navTitle: '基础组件',
    description: '文字、图标、图片、头像和语义状态，是构成一致移动端界面的最小单元。',
    page: '/components/foundations',
    demos: [
      demo('atoms', '基础元素完整状态', 'complete_examples.dart', 740, '文字、图标、头像、图片和语义标签。'),
      demo('data', '徽标、列表与进度', 'data_example.dart', 460, '用于检查数据展示组件的常用组合。'),
    ],
    components: [
      component('HyText / HyTextStyle', 'hy_typography.dart', '统一的显示、标题、正文、说明和提示文字层级。', {
        propsDocs: [
          { name: 'data', description: '显示的文本内容' },
          { name: 'variant', description: '文字样式层级，默认 HyTextStyle.body' },
          { name: 'color', description: '文字颜色' },
          { name: 'weight', description: '字重' },
          { name: 'maxLines', description: '最大行数' },
          { name: 'textAlign', description: '文字对齐方式' },
        ],
        preview: demo('component-text', 'HyText 文字层级', 'component_foundation_examples.dart', 480, '六种文字层级与颜色、字重、行数截断。', 'TextComponentExample'),
      }),
      component('HyIcon / HyIcons', 'hy_typography.dart', '带语义标签的图标组件与常用业务图标集合。', {
        propsDocs: [
          { name: 'icon', description: '图标数据，IconData 类型' },
          { name: 'size', description: '图标大小，默认 24' },
          { name: 'color', description: '图标颜色' },
          { name: 'label', description: '语义化标签，用于无障碍' },
        ],
        preview: demo('component-icon', 'HyIcon 图标', 'component_foundation_examples.dart', 340, '常用语义图标、无障碍标签与尺寸颜色。', 'IconComponentExample'),
      }),
      component('HyImage', 'hy_image.dart', '支持 ImageProvider、网络、资源、占位、失败态与缩放预览。', {
        propsDocs: [
          { name: 'provider', description: '图片数据源，ImageProvider 类型' },
          { name: 'width', description: '图片宽度' },
          { name: 'height', description: '图片高度' },
          { name: 'radius', description: '圆角大小，默认 16' },
          { name: 'fit', description: '图片适配方式，默认 BoxFit.cover' },
          { name: 'placeholder', description: '加载中占位组件' },
          { name: 'errorPlaceholder', description: '加载失败占位组件' },
          { name: 'preview', description: '是否点击进入全屏预览，默认 false' },
          { name: 'semanticLabel', description: '语义化标签，用于无障碍' },
        ],
        preview: demo('component-image', 'HyImage 图片', 'component_foundation_examples.dart', 480, '网络图片点击预览、加载占位与失败兜底。', 'ImageComponentExample'),
      }),
      component('HyAvatar', 'hy_image.dart', '图片、文字或默认图标头像，支持圆形和自定义圆角。', {
        propsDocs: [
          { name: 'image', description: '头像图片数据源，ImageProvider 类型' },
          { name: 'text', description: '文字头像内容' },
          { name: 'size', description: '头像尺寸，默认 40' },
          { name: 'radius', description: '圆角大小，为空时为圆形' },
          { name: 'backgroundColor', description: '背景颜色' },
        ],
        preview: demo('component-avatar', 'HyAvatar 头像', 'component_foundation_examples.dart', 380, '文字头像、尺寸、圆角与背景色。', 'AvatarComponentExample'),
      }),
      component('HyBadge', 'hy_badge.dart', '状态、可交互标签与数字角标共用的徽标。', {
        propsDocs: [
          { name: 'label', description: '徽标文字' },
          { name: 'tone', description: '语义色调，默认 HyUiTone.neutral' },
          { name: 'icon', description: '前置图标' },
          { name: 'subtle', description: '状态徽标是否使用弱化样式，默认 true' },
          { name: 'selected', description: 'HyBadge.tag 的选中态' },
          { name: 'onTap / onClose', description: 'HyBadge.tag 的点击与移除回调' },
          { name: 'child / count / max / dot / showZero', description: 'HyBadge.count 的角标内容与显示规则' },
        ],
        preview: demo('component-badge', 'HyBadge 徽标', 'component_foundation_examples.dart', 700, '状态、数字角标、可选择与可移除标签。', 'BadgeComponentExample'),
      }),
      component('HyUiTone / HyUiToneResolver', 'hy_tone.dart', '跨组件共用的语义状态及其主题颜色解析扩展。', {
        sidebar: false,
        preview: demo('component-ui-tone', 'HyUiTone 语义色', 'component_foundation_examples.dart', 300, '五种跨组件语义状态与说明。', 'ToneComponentExample'),
      }),
    ],
  },
  {
    id: 'actions',
    title: '材质与操作',
    navTitle: '材质与操作',
    description: '玻璃表面、即时按压反馈、动作层级和内容容器。',
    page: '/components/actions',
    demos: [
      demo('buttons', '按钮层级、尺寸、状态与图标按钮', 'buttons_example.dart', 360, '点击真实按钮，检查图标、加载态、胶囊圆形与不同尺寸。'),
      demo('cards', '卡片结构与选择状态', 'cards_example.dart', 520, '包含标题、状态、进度、标签和选中态。'),
    ],
    components: [
      component('HyButton / HyButtonVariant', 'hy_button.dart', '五种视觉层级（具名构造 filled/tonal/outline/ghost/danger 优先）、高度数值可调、加载、禁用、图标按钮和通栏状态。', {
        propsDocs: [
          { name: 'label', description: '按钮文字；省略时配合 icon 自动呈现方形图标按钮' },
          { name: 'onPressed', description: '点击回调；为 null 时按钮进入禁用态' },
          { name: 'variant', description: '视觉层级，默认 HyButtonVariant.filled；程序化切换时使用，声明式场景建议用下方具名构造' },
          { name: 'height', description: '按钮高度（px），默认 38；字号、内边距、图标尺寸随高度联动推导' },
          { name: 'icon', description: '前置图标；label 省略时切换为图标按钮' },
          { name: 'trailingIcon', description: '后置图标' },
          { name: 'loading', description: '是否显示加载态，默认 false；加载期间禁止点击' },
          { name: 'expanded', description: '是否通栏铺满，默认 false；不传时按内容收缩（等价 inline-block）' },
          { name: 'radius', description: '圆角大小，默认 HyUiRadii.sm（16）；round/circle 为 true 时忽略，恒取高度一半' },
          { name: 'round', description: '胶囊圆角，默认 false' },
          { name: 'circle', description: '宽高相等并取胶囊圆角，默认 false' },
          { name: 'iconSize', description: '图标尺寸覆盖，默认随高度联动' },
          { name: 'tooltip', description: '悬停或长按提示文字' },
          { name: 'semanticLabel', description: '语义化标签，用于无障碍朗读' },
          { name: 'color', description: '覆盖前景色，图标按钮可直接指定图标颜色' },
          { name: 'backgroundColor', description: '覆盖按钮背景色，图标按钮默认使用玻璃表面' },
        ],
        preview: demo('component-button', 'HyButton 状态', 'buttons_example.dart', 360, '展示按钮层级、尺寸、状态、图标按钮与宽度表现。'),
      }),
      component('HyCard', 'hy_card.dart', '具有标题、操作区、正文、底部和选中态的内容容器。', {
        propsDocs: [
          { name: 'child', description: '正文内容组件' },
          { name: 'title', description: '标题' },
          { name: 'subtitle', description: '副标题' },
          { name: 'leading', description: '前置组件' },
          { name: 'actions', description: '操作区组件列表，默认空数组' },
          { name: 'footer', description: '底部组件' },
          { name: 'padding', description: '内边距' },
          { name: 'onTap', description: '点击回调' },
          { name: 'selected', description: '是否选中，默认 false' },
          { name: 'radius', description: '圆角大小' },
          { name: 'blur', description: '模糊度，默认 18' },
          { name: 'weight', description: '玻璃材质重量，默认 HyGlassWeight.regular' },
          { name: 'borderColor', description: '边框颜色' },
          { name: 'shadows', description: '阴影列表' },
        ],
        preview: demo('component-card', 'HyCard 结构', 'component_surface_examples.dart', 560, '完整结构、选中态与无标题纯内容。', 'CardComponentExample'),
      }),
      component('HyGlass', 'hy_glass.dart', '可配置模糊、背景、边框、阴影和点击行为的玻璃材质。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'padding', description: '内边距，默认 EdgeInsets.zero' },
          { name: 'radius', description: '圆角大小，默认 24' },
          { name: 'blur', description: '模糊度' },
          { name: 'weight', description: '玻璃材质重量，默认 HyGlassWeight.regular' },
          { name: 'borderColor', description: '边框颜色' },
          { name: 'shadows', description: '阴影列表' },
          { name: 'color', description: '背景颜色' },
          { name: 'onTap', description: '点击回调' },
          { name: 'clipBehavior', description: '裁剪行为，默认 Clip.antiAlias' },
        ],
        preview: demo('component-glass', 'HyGlass 材质', 'component_surface_examples.dart', 420, '四档材质重量与自定义圆角、模糊。', 'GlassComponentExample'),
      }),
      component('HyGlassWeight', 'hy_glass.dart', '按表面面积和层级区分轻薄、标准、突出与实色材质。', {
        sidebar: false,
        preview: demo('component-glass-weight', 'HyGlassWeight 材质重量', 'component_action_examples.dart', 300, '对比四种玻璃材质重量。', 'GlassWeightComponentExample'),
      }),
      component('HyPressable', 'hy_pressable.dart', '按下即响应、可适配减少动画的通用触控反馈层。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'onPressed', description: '点击回调' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'pressedScale', description: '按下时缩放比例，默认 0.975' },
          { name: 'pressedOpacity', description: '按下时透明度，默认 0.92' },
          { name: 'borderRadius', description: '圆角' },
          { name: 'semanticLabel', description: '语义化标签' },
        ],
        preview: demo('component-pressable', 'HyPressable 按压反馈', 'component_action_examples.dart', 280, '按住表面感受即时缩放与透明度反馈。', 'PressableComponentExample'),
      }),
      component('HySoftBackground', 'hy_glass.dart', '为页面提供与明暗主题同步的柔光背景。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'intensity', description: '柔光强度，默认 1' },
        ],
        preview: demo('component-soft-background', 'HySoftBackground 柔光背景', 'component_action_examples.dart', 320, '展示环境色与玻璃材质的景深关系。', 'SoftBackgroundComponentExample'),
      }),
    ],
    conventions: [
      '按表面面积选择 `HyGlassWeight`：小控件用 `subtle`，普通卡片用 `regular`，模态浮层用 `prominent`。',
      '密集列表中可设置 `HyGlass.blur: 0`，保留材质外观并降低模糊绘制成本。',
      '不要在轻量玻璃表面上继续叠加轻量玻璃；选中态优先使用颜色状态而不是新增一层材质。',
    ],
  },
  {
    id: 'layout',
    title: '布局组件',
    navTitle: '布局组件',
    description: '间距、换行、网格、分割、动态骨架与空状态。',
    page: '/components/layout',
    demos: [
      demo('layout', '布局容器与占位状态', 'complete_examples.dart', 740),
    ],
    components: [
      component('HySpace', 'hy_layout.dart', '在线性方向排列子项并统一插入间距。', {
        propsDocs: [
          { name: 'children', description: '子组件列表' },
          { name: 'direction', description: '排列方向，默认 Axis.vertical' },
          { name: 'spacing', description: '间距大小，默认 12' },
          { name: 'alignment', description: '交叉轴对齐方式，默认 CrossAxisAlignment.start' },
        ],
        preview: demo('component-space', 'HySpace 间距布局', 'component_layout_examples.dart', 340, '垂直排列（默认）与水平方向、自定义间距。', 'SpaceComponentExample'),
      }),
      component('HyDivider', 'hy_layout.dart', '横向或纵向、实线或虚线分隔。', {
        propsDocs: [
          { name: 'axis', description: '方向，默认 Axis.horizontal' },
          { name: 'indent', description: '起始缩进，默认 0' },
          { name: 'endIndent', description: '结束缩进，默认 0' },
          { name: 'dashed', description: '是否虚线，默认 false' },
          { name: 'length', description: '长度' },
          { name: 'color', description: '颜色' },
        ],
        preview: demo('component-divider', 'HyDivider 分割线', 'component_layout_examples.dart', 300, '实线、虚线、缩进与纵向分隔。', 'DividerComponentExample'),
      }),
      component('HySkeleton', 'hy_layout.dart', '适配减少动画设置的列表或卡片扫光占位。', {
        propsDocs: [
          { name: 'rows', description: '骨架行数，默认 3' },
          { name: 'card', description: '是否为卡片样式，默认 false' },
        ],
        preview: demo('component-skeleton', 'HySkeleton 骨架屏', 'component_feedback_examples.dart', 500, '卡片骨架与列表骨架两种形态。', 'SkeletonComponentExample'),
      }),
      component('HyEmptyState', 'hy_empty_state.dart', '包含图标、标题、说明和操作的空状态。', {
        propsDocs: [
          { name: 'icon', description: '图标，IconData 类型' },
          { name: 'title', description: '标题' },
          { name: 'message', description: '说明文字' },
          { name: 'action', description: '操作按钮组件' },
        ],
        preview: demo('component-empty-state', 'HyEmptyState 空状态', 'component_layout_examples.dart', 420, '带恢复操作与纯提示两种空状态。', 'EmptyStateComponentExample'),
      }),
    ],
  },
  {
    id: 'forms',
    title: '表单组件',
    navTitle: '表单组件',
    description: '受控输入、锚定下拉、底部选择器、日期时间与注入式文件上传。',
    page: '/components/forms',
    demos: [
      demo('inputs', '基础输入与分段选择', 'inputs_example.dart', 520, '用于快速检查输入、辅助文案和受控选择。'),
      demo('forms', '完整表单交互', 'complete_examples.dart', 900, '覆盖校验、选择、日期和上传入口。'),
      demo('upload', '上传状态与重试', 'upload_example.dart', 680, '模拟选择、上传进度、取消、失败、重试与禁用，不依赖平台插件。'),
    ],
    components: [
      component('HyTextField', 'hy_text_field.dart', '纯文本输入控件：支持单行/多行、密码、清空、前后缀插槽、字数统计与错误态，默认不带标题和图标。', {
        propsDocs: [
          { name: 'controller', description: '文本编辑控制器，为空时按 initialValue 内部维护' },
          { name: 'focusNode', description: '焦点节点' },
          { name: 'hintText', description: '占位提示文字' },
          { name: 'errorText', description: '错误提示文字，传入即为错误态' },
          { name: 'prefix', description: '前缀插槽，可放置图标等任意组件' },
          { name: 'suffix', description: '后缀插槽，可放置任意组件' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'readOnly', description: '是否只读，默认 false' },
          { name: 'obscureText', description: '是否隐藏输入内容（密码模式），默认 false' },
          { name: 'showPasswordToggle', description: '是否显示密码显隐按钮，默认 false' },
          { name: 'clearable', description: '是否显示清空按钮，默认 false' },
          { name: 'maxLines', description: '最大行数，默认 1' },
          { name: 'minLines', description: '最小行数' },
          { name: 'maxLength', description: '最大字符数，超出阻止输入' },
          { name: 'showCounter', description: '是否显示字符计数，需配合 maxLength，默认 false' },
          { name: 'autofocus', description: '是否自动获取焦点，默认 false' },
          { name: 'textAlign', description: '文本对齐方式，默认 TextAlign.start' },
          { name: 'keyboardType', description: '键盘类型' },
          { name: 'textInputAction', description: '键盘动作按钮类型' },
          { name: 'textCapitalization', description: '大小写模式，默认 TextCapitalization.none' },
          { name: 'autofillHints', description: '自动填充提示' },
          { name: 'onChanged', description: '内容变化回调' },
          { name: 'onSubmitted', description: '提交回调' },
          { name: 'onTap', description: '点击回调' },
          { name: 'validator', description: '表单校验函数' },
          { name: 'initialValue', description: '无 controller 时的初始值' },
        ],
        preview: demo('component-text-field', 'HyTextField 输入框', 'component_form_examples.dart', 860, '展示基础、清空、密码、前后缀、多行、计数、禁用只读与错误态。', 'TextFieldComponentExample'),
      }),
      component('HyFormField', 'hy_form_field.dart', '为任意输入控件统一排列标题、必填标记、辅助文案和错误提示。', {
        propsDocs: [
          { name: 'label', description: '字段标题' },
          { name: 'child', description: '输入控件' },
          { name: 'helperText', description: '正常状态辅助说明' },
          { name: 'errorText', description: '错误提示，存在时替代辅助说明' },
          { name: 'isRequired', description: '是否显示必填标记，默认 false' },
          { name: 'trailing', description: '标题右侧附加组件' },
        ],
        preview: demo('component-form-field', 'HyFormField 字段容器', 'component_form_field_example.dart', 360, '文本输入与数值控件共享标题、说明和错误层级。', 'FormFieldComponentExample'),
      }),
      component('HySegmentedControl / HySegmentOption', 'hy_segmented_control.dart', '适用于少量互斥选项的受控分段选择。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'selectedValue', description: '当前选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'equalWidth', description: '是否等宽，默认 true' },
        ],
        preview: demo('component-segmented-control', 'HySegmentedControl 分段选择', 'component_form_examples.dart', 500, '受控切换、非等宽布局、图标选项与禁用项。', 'SegmentedControlComponentExample'),
      }),
      component('HySelect / HyOption', 'hy_select.dart', '底部弹层单选或多选，支持禁用项。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'values', description: '已选中值列表' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'multiple', description: '是否多选，默认 false' },
          { name: 'placeholder', description: '占位文字，默认 请选择' },
          { name: 'label', description: '选择框上方的字段标题' },
        ],
        preview: demo('component-select', 'HySelect 底部选择', 'component_form_examples.dart', 480, '单选、多选、禁用项与占位文案。', 'SelectComponentExample'),
      }),
      component('HyDropdown', 'hy_dropdown.dart', '锚定触发器展开、适合在选择时保持页面上下文的泛型下拉。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'value', description: '当前选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'label', description: '选择框上方的字段标题' },
          { name: 'placeholder', description: '占位文字，默认 请选择' },
          { name: 'menuMaxHeight', description: '下拉菜单最大高度，默认 320' },
          { name: 'width', description: '宽度' },
        ],
        preview: demo('component-dropdown', 'HyDropdown 下拉菜单', 'component_form_examples.dart', 420, '带标签单选、占位与禁用项、固定宽度与菜单高度。', 'DropdownComponentExample'),
      }),
      component('HyCheckbox', 'hy_selection_controls.dart', '支持三态、禁用和标签的受控复选。', {
        propsDocs: [
          { name: 'value', description: '是否选中' },
          { name: 'onChanged', description: '状态变化回调' },
          { name: 'label', description: '标签文字' },
          { name: 'tristate', description: '是否三态，默认 false' },
        ],
        preview: demo('component-checkbox', 'HyCheckbox 复选框', 'component_form_examples.dart', 520, '受控复选、三态、禁用与无标签纯控件。', 'CheckboxComponentExample'),
      }),
      component('HyRadio', 'hy_selection_controls.dart', '泛型值受控单选。', {
        propsDocs: [
          { name: 'value', description: '当前选项值' },
          { name: 'groupValue', description: '组选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'label', description: '标签文字' },
        ],
        preview: demo('component-radio', 'HyRadio 单选框', 'component_form_examples.dart', 420, '互斥单选组与禁用项。', 'RadioComponentExample'),
      }),
      component('HySwitch', 'hy_selection_controls.dart', '布尔值受控开关。', {
        propsDocs: [
          { name: 'value', description: '是否开启' },
          { name: 'onChanged', description: '状态变化回调' },
          { name: 'label', description: '标签文字' },
        ],
        preview: demo('component-switch', 'HySwitch 开关', 'component_form_examples.dart', 500, '受控开关、禁用与无标签纯控件。', 'SwitchComponentExample'),
      }),
      component('HySlider', 'hy_selection_controls.dart', '范围、分段和结束回调可配置的滑块。', {
        propsDocs: [
          { name: 'value', description: '当前值' },
          { name: 'onChanged', description: '拖动中回调' },
          { name: 'onChangeStart', description: '开始拖动回调' },
          { name: 'onChangeEnd', description: '结束拖动回调' },
          { name: 'min', description: '最小值，默认 0' },
          { name: 'max', description: '最大值，默认 100' },
          { name: 'divisions', description: '分段数' },
          { name: 'showValue', description: '是否显示当前值，默认 true' },
        ],
        preview: demo('component-slider', 'HySlider 滑块', 'component_form_examples.dart', 560, '连续取值、离散分段、自定义范围与提交回调。', 'SliderComponentExample'),
      }),
      component('HyNumberStepper', 'hy_number_stepper.dart', '用于整数数量的紧凑受控增减器，支持上下限和步长。', {
        propsDocs: [
          { name: 'value', description: '当前整数值，需处于上下限范围内' },
          { name: 'onChanged', description: '值变化回调；为空时只读' },
          { name: 'min', description: '最小值，默认 0' },
          { name: 'max', description: '最大值，默认 99' },
          { name: 'step', description: '每次增减的步长，默认 1' },
          { name: 'semanticLabel', description: '数值的无障碍名称' },
        ],
        preview: demo('component-number-stepper', 'HyNumberStepper 数值步进', 'component_number_stepper_example.dart', 330, '数量、步长、边界与只读状态。', 'NumberStepperComponentExample'),
      }),
      component('HyPicker', 'hy_picker.dart', '通过滚轮完成普通选项选择。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'initialIndex', description: '初始选中索引，默认 0' },
          { name: 'title', description: '标题，默认 选择选项' },
        ],
        preview: demo('component-picker', 'HyPicker 滚轮选择器', 'component_form_examples.dart', 420, '基础滚轮选择与指定初始项。', 'PickerComponentExample'),
      }),
      component('HyDatePicker', 'hy_date_picker.dart', '在统一玻璃底部弹层中选择日期、时间和日期区间。', {
        propsDocs: [
          { name: 'initialDate', description: '初始日期' },
          { name: 'initialTime', description: '初始时间' },
          { name: 'initialRange', description: '初始日期区间' },
          { name: 'firstDate', description: '最早可选日期' },
          { name: 'lastDate', description: '最晚可选日期' },
        ],
        preview: demo('component-date-picker', 'HyDatePicker 日期选择', 'component_form_examples.dart', 500, '日期、时间与日期区间三种入口。', 'DatePickerComponentExample'),
      }),
      component('HyUploader / HyUploadSource / HyUploadStatus / HyUploadFile / HyUploadCancellation / HyUploadItem', 'hy_uploader.dart', '通过注入式适配器完成选择、上传、进度、取消、失败与重试。', {
        propsDocs: [
          { name: 'pick', description: '文件选择器，HyFilePicker 类型' },
          { name: 'upload', description: '文件上传器，HyFileUpload 类型' },
          { name: 'onChanged', description: '上传列表变化回调' },
          { name: 'onError', description: '错误回调' },
          { name: 'initialItems', description: '初始上传项列表，默认空数组' },
          { name: 'maxCount', description: '最大文件数，默认 9' },
          { name: 'maxBytes', description: '单文件最大字节数，默认 10MB' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'sources', description: '可选上传来源，默认相册和相机' },
        ],
        preview: demo('component-uploader', 'HyUploader 上传', 'upload_example.dart', 680, '文件选择、进度、取消、重试与禁用状态。'),
      }),
      component('HyFilePicker / HyFileUpload', 'hy_uploader.dart', '由业务层实现的文件选择与上传函数类型。', {
        sidebar: false,
        preview: demo('component-file-picker', '文件能力注入', 'component_form_examples.dart', 280, '说明选择器与上传器的职责边界。', 'FilePickerComponentExample'),
      }),
    ],
    conventions: [
      '`HySelect.values` 是已提交值；多选仅在确认后触发 `onChanged`。',
      '上传组件不直接依赖相册、文件系统或 HTTP 插件，平台能力通过 `HyFilePicker` 与 `HyFileUpload` 注入。',
    ],
  },
  {
    id: 'feedback',
    title: '反馈与浮层',
    navTitle: '反馈与浮层',
    description: '玻璃 Toast、对话框、加载、通知、Drawer、BottomSheet 与锚点菜单。',
    page: '/components/feedback',
    demos: [
      demo('feedback', '基础反馈状态', 'feedback_example.dart', 520, '空状态、徽标和常用反馈组合。'),
      demo('overlays', '反馈与弹层交互', 'interactive_examples.dart', 700, '可实际打开 Toast、Dialog、BottomSheet、Popover 和加载层。'),
      demo('drawer', '抽屉交互', 'drawer_example.dart', 620, '检查左右抽屉、固定底部操作和返回值。'),
    ],
    components: [
      component('HyToast', 'hy_feedback.dart', '支持语义色和可选撤销动作的玻璃轻提示。', {
        propsDocs: [
          { name: 'tone', description: '语义色调，默认 HyUiTone.neutral' },
          { name: 'duration', description: '显示时长，默认 2 秒' },
          { name: 'actionLabel', description: '操作按钮文字' },
          { name: 'onAction', description: '操作按钮回调' },
        ],
        preview: demo('component-toast', 'HyToast 轻提示', 'component_feedback_examples.dart', 380, '四种语义色调、操作按钮与显示时长。', 'ToastComponentExample'),
      }),
      component('HyDialog', 'hy_feedback.dart', '确认、提示或自定义正文对话框。', {
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'message', description: '提示文字' },
          { name: 'content', description: '自定义正文组件' },
          { name: 'confirmLabel', description: '确认按钮文字，默认 确定' },
          { name: 'cancelLabel', description: '取消按钮文字，默认 取消' },
          { name: 'dangerous', description: '是否危险操作样式，默认 false' },
          { name: 'showCancel', description: '是否显示取消按钮，默认 true' },
        ],
        preview: demo('component-dialog', 'HyDialog 对话框', 'component_feedback_examples.dart', 420, '标准确认、危险操作、仅确认按钮与自定义正文。', 'DialogComponentExample'),
      }),
      component('HyLoading', 'hy_feedback.dart', '局部加载状态与自动清理的全局任务遮罩。', {
        propsDocs: [
          { name: 'label', description: '加载提示文字' },
          { name: 'size', description: '加载图标大小，默认 24' },
        ],
        preview: demo('component-loading', 'HyLoading 加载', 'component_feedback_examples.dart', 420, '局部加载（尺寸与文案）与全局任务遮罩。', 'LoadingComponentExample'),
      }),
      component('HyAlert', 'hy_feedback.dart', '可关闭的语义通知。', {
        propsDocs: [
          { name: 'message', description: '通知内容' },
          { name: 'title', description: '标题' },
          { name: 'tone', description: '语义色调，默认 HyUiTone.info' },
          { name: 'onClose', description: '关闭回调' },
        ],
        preview: demo('component-alert', 'HyAlert 通知', 'component_feedback_examples.dart', 620, '四种语义色调、无标题与可关闭。', 'AlertComponentExample'),
      }),
      component('HyDrawer / HyDrawerPlacement', 'hy_drawer.dart', '支持双侧弹出、RTL、自定义宽度、固定底部操作区与泛型返回结果的柔光抽屉。', {
        propsDocs: [
          { name: 'child', description: '内容组件' },
          { name: 'title', description: '标题' },
          { name: 'footer', description: '底部操作区组件' },
          { name: 'onClose', description: '关闭回调' },
          { name: 'scrollable', description: '是否可滚动，默认 true' },
          { name: 'padding', description: '内边距' },
        ],
        preview: demo('component-drawer', 'HyDrawer 抽屉', 'component_feedback_examples.dart', 460, '右侧抽屉返回值、左侧抽屉与底部操作区。', 'DrawerComponentExample'),
      }),
      component('HyActionSheet / HyAction', 'hy_action_sheet.dart', '统一的自定义底部弹层与操作菜单，支持危险项和禁用项。', {
        propsDocs: [
          { name: 'builder', description: '自定义内容构建器，与 actions 二选一' },
          { name: 'actions', description: '操作项列表' },
          { name: 'title', description: '标题' },
          { name: 'dismissible', description: '是否可点击外部关闭，默认 true' },
          { name: 'cancelLabel', description: '取消按钮文字，默认 取消' },
        ],
        preview: demo('component-action-sheet', 'HyActionSheet 底部弹层', 'component_feedback_examples.dart', 420, '自定义内容、操作列表与不可点外关闭的弹层。', 'ActionSheetComponentExample'),
      }),
      component('HyPopover', 'hy_popover.dart', '锚定子组件的补充说明气泡。', {
        propsDocs: [
          { name: 'child', description: '锚点子组件' },
          { name: 'content', description: '气泡内容组件' },
        ],
        preview: demo('component-popover', 'HyPopover 气泡', 'component_feedback_examples.dart', 260, '点击锚点查看补充说明。', 'PopoverComponentExample'),
      }),
      component('HyTooltip', 'hy_tooltip.dart', '悬停、长按或键盘聚焦时出现的轻量玻璃提示。', {
        propsDocs: [
          { name: 'message', description: '提示文字' },
          { name: 'child', description: '锚点组件' },
          { name: 'hoverDelay', description: '悬停显示延迟，默认 500 毫秒' },
          { name: 'maxWidth', description: '提示最大宽度，默认 240' },
        ],
        preview: demo('component-tooltip', 'HyTooltip 轻提示', 'component_tooltip_example.dart', 260, '悬停、长按与键盘聚焦。', 'TooltipComponentExample'),
      }),
      component('HyPopupMenu', 'hy_popover.dart', '基于 HyAction 的泛型弹出菜单。', {
        propsDocs: [
          { name: 'actions', description: '菜单项列表' },
          { name: 'onSelected', description: '选中回调' },
          { name: 'icon', description: '触发图标，默认 LucideIcons.ellipsis' },
          { name: 'tooltip', description: '长按提示文字，默认 更多操作' },
        ],
        preview: demo('component-popup-menu', 'HyPopupMenu 弹出菜单', 'component_feedback_examples.dart', 260, '选择菜单项并读取泛型返回值。', 'PopupMenuComponentExample'),
      }),
      component('HyNoticeBar', 'hy_notice_bar.dart', '短公告静止、长公告滚动的可关闭通知条。', {
        propsDocs: [
          { name: 'message', description: '公告内容' },
          { name: 'onTap', description: '点击回调' },
          { name: 'onClose', description: '关闭回调' },
          { name: 'speed', description: '滚动速度，默认 28' },
        ],
        preview: demo('component-notice-bar', 'HyNoticeBar 公告栏', 'component_feedback_examples.dart', 400, '短公告静止、长公告滚动与关闭。', 'NoticeBarComponentExample'),
      }),
    ],
    conventions: ['`HyLoading.during` 会在 `finally` 中仅移除自己的遮罩，任务异常继续交给调用方。'],
  },
  {
    id: 'navigation',
    title: '导航与菜单',
    navTitle: '导航与菜单',
    description: 'Navbar、可拖拽 TabBar、标签、步骤、进度、列表、分组菜单与侧滑操作。',
    page: '/components/navigation',
    demos: [
      demo('navigation', '基础导航', 'navigation_example.dart', 520),
      demo('full-navigation', '导航、步骤与列表联动', 'complete_examples.dart', 860),
    ],
    components: [
      component('HyNavBar', 'hy_nav_bar.dart', '支持副标题、自定义前导、操作区和悬浮材质的页面顶部栏。', {
        id: 'nav-bar',
        navName: 'HyNavBar',
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'subtitle', description: '副标题' },
          { name: 'leading', description: '前导组件' },
          { name: 'actions', description: '操作区组件列表，默认空数组' },
          { name: 'safeArea', description: '是否适配安全区，默认 true' },
          { name: 'automaticallyImplyLeading', description: '是否自动添加返回按钮，默认 true' },
          { name: 'centerTitle', description: '标题是否居中，默认 false' },
          { name: 'floating', description: '是否悬浮材质，默认 false' },
        ],
        preview: demo('component-nav-bar', 'HyNavBar 顶部导航', 'component_navigation_examples.dart', 300, '基础（返回 + 居中标题）与悬浮模式。', 'NavBarComponentExample'),
      }),
      component('HyTabBar / HyTabItem', 'hy_tab_bar.dart', '透明水珠按压与拖动放大、绿色选中态、释放吸附的悬浮底栏。', {
        propsDocs: [
          { name: 'items', description: '导航项列表' },
          { name: 'selectedIndex', description: '当前选中索引' },
          { name: 'onSelected', description: '选中回调' },
          { name: 'safeArea', description: '是否适配安全区，默认 true' },
          { name: 'enableHaptics', description: '是否启用触感反馈，默认 true' },
          { name: 'activeColor', description: '选中图文颜色，默认绿色' },
          { name: 'margin', description: '外边距' },
        ],
        preview: demo('component-tab-bar', 'HyTabBar 底部导航', 'component_navigation_examples.dart', 320, '长按并拖动，观察水珠放大、跟手和收回。', 'TabBarComponentExample'),
      }),
      component('HyTabs', 'hy_navigation.dart', '与 Flutter TabBarView 共享 TabController 的玻璃标签栏。', {
        propsDocs: [
          { name: 'tabs', description: '标签组件列表' },
          { name: 'controller', description: 'TabController 控制器' },
          { name: 'scrollable', description: '标签是否可滚动，默认 false' },
          { name: 'onTap', description: '标签点击回调' },
        ],
        preview: demo('component-tabs', 'HyTabs 标签页', 'component_navigation_examples.dart', 350, '点击标签或横向滑动页面。', 'TabsComponentExample'),
      }),
      component('HyCarousel', 'hy_carousel.dart', '支持滑动、可选自动播放和页码回调的紧凑轮播。', {
        propsDocs: [
          { name: 'items', description: '轮播页面，至少一个' },
          { name: 'height', description: '页面高度，默认 180' },
          { name: 'initialIndex', description: '初始页索引，默认 0' },
          { name: 'onPageChanged', description: '页面变化回调' },
          { name: 'showIndicator', description: '是否显示页码指示器，默认 true' },
          { name: 'autoPlayInterval', description: '自动播放间隔，需大于 350 毫秒；为空时不自动播放' },
        ],
        preview: demo('component-carousel', 'HyCarousel 轮播', 'component_carousel_example.dart', 280, '滑动切页与页码同步。', 'CarouselComponentExample'),
      }),
      component('HyPageIndicator', 'hy_carousel.dart', '可独立使用的受控页码指示器。', {
        propsDocs: [
          { name: 'count', description: '总页数，必须大于 0' },
          { name: 'index', description: '当前页索引，从 0 开始' },
          { name: 'onSelected', description: '点击页码回调；为空时只读' },
        ],
        preview: demo('component-page-indicator', 'HyPageIndicator 页码指示', 'component_carousel_example.dart', 200, '可点击与只读状态。', 'PageIndicatorComponentExample'),
      }),
      component('HySteps / HyStep', 'hy_navigation.dart', '横向或纵向步骤状态。', {
        propsDocs: [
          { name: 'steps', description: '步骤项列表' },
          { name: 'current', description: '当前步骤索引' },
          { name: 'vertical', description: '是否纵向排列，默认 false' },
        ],
        preview: demo('component-steps', 'HySteps 步骤', 'component_navigation_examples.dart', 420, '水平受控步骤与纵向步骤（可带副标题）。', 'StepsComponentExample'),
      }),
      component('HyProgress', 'hy_navigation.dart', '线性、环形、确定或不定进度。', {
        propsDocs: [
          { name: 'value', description: '进度值（0-1），为空时为不定进度' },
          { name: 'circular', description: '是否环形，默认 false' },
          { name: 'size', description: '环形尺寸，默认 64' },
          { name: 'showLabel', description: '是否显示百分比文字，默认 true' },
          { name: 'strokeWidth', description: '环形或线性进度条的厚度，默认 6' },
          { name: 'color', description: '进度颜色' },
          { name: 'backgroundColor', description: '轨道颜色' },
        ],
        preview: demo('component-progress', 'HyProgress 进度', 'component_navigation_examples.dart', 360, '线性粗细、环形和不定进度。', 'ProgressComponentExample'),
      }),
      component('HyListTile', 'hy_list_tile.dart', '支持图标、头像、标签、元信息和自定义尾部的列表项。', {
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'subtitle', description: '副标题' },
          { name: 'meta', description: '元信息文字' },
          { name: 'leading', description: '前置组件' },
          { name: 'leadingIcon', description: '前置图标' },
          { name: 'leadingColor', description: '前置图标颜色' },
          { name: 'trailing', description: '尾部组件' },
          { name: 'onTap', description: '点击回调' },
          { name: 'selected', description: '是否选中，默认 false' },
          { name: 'grouped', description: '是否分组样式，默认 false' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'showChevron', description: '是否显示右箭头，默认 true' },
        ],
        preview: demo('component-list-tile', 'HyListTile 列表项', 'component_navigation_examples.dart', 400, '基础、选中/禁用与自定义插槽（showChevron）。', 'ListTileComponentExample'),
      }),
      component('HyMenuGroup', 'hy_lists.dart', '设置页、个人中心和详情页通用的玻璃分组菜单。', {
        propsDocs: [
          { name: 'children', description: 'HyListTile 等分组内容' },
          { name: 'title', description: '分组标题' },
          { name: 'subtitle', description: '分组副标题' },
        ],
        preview: demo('component-menu-group', 'HyMenuGroup 分组菜单', 'component_navigation_examples.dart', 420, '只展示设置页式分组菜单。', 'MenuGroupComponentExample'),
      }),
      component('HySlideMenu / HySlideAction', 'hy_slide_menu.dart', '支持 RTL、速度投影、弹簧吸附与边界阻尼的侧滑菜单。', {
        propsDocs: [
          { name: 'child', description: '内容组件' },
          { name: 'startActions', description: '左侧操作列表，默认空数组' },
          { name: 'endActions', description: '右侧操作列表，默认空数组' },
          { name: 'actionExtent', description: '操作区域宽度，默认 72' },
          { name: 'radius', description: '圆角大小，默认 18' },
          { name: 'enabled', description: '是否启用侧滑，默认 true' },
          { name: 'decorateChild', description: '是否为内容添加材质装饰，默认 true' },
        ],
        preview: demo('component-slide-menu', 'HySlideMenu 侧滑菜单', 'component_navigation_examples.dart', 300, '左右拖动列表行查看快捷操作。', 'SlideMenuComponentExample'),
      }),
      component('HyPullRefresh', 'hy_lists.dart', '对 RefreshIndicator 的语义化封装。', {
        propsDocs: [
          { name: 'onRefresh', description: '刷新回调' },
          { name: 'child', description: '子组件' },
        ],
        preview: demo('component-pull-refresh', 'HyPullRefresh 下拉刷新', 'component_navigation_examples.dart', 360, '下拉列表触发异步刷新。', 'PullRefreshComponentExample'),
      }),
      component('HyLoadMore', 'hy_lists.dart', '串行分页、终态与失败重试。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'onLoadMore', description: '加载更多回调' },
          { name: 'hasMore', description: '是否还有更多数据' },
          { name: 'threshold', description: '触发加载的距离阈值，默认 160' },
        ],
        preview: demo('component-load-more', 'HyLoadMore 分页加载', 'component_navigation_examples.dart', 480, '滚动到底自动加载与 hasMore: false 终态。', 'LoadMoreComponentExample'),
      }),
      component('HyPagination', 'hy_pagination.dart', '支持跳页、省略号和 RTL 的受控分页导航。', {
        propsDocs: [
          { name: 'page', description: '当前页，从 1 开始；空数据时为 0' },
          { name: 'pageCount', description: '总页数；无数据时传 0' },
          { name: 'onChanged', description: '页码变化回调；为空时只读' },
          { name: 'maxVisiblePages', description: '中间可见页码数，默认 5' },
        ],
        preview: demo('component-pagination', 'HyPagination 分页导航', 'component_pagination_example.dart', 260, '跳页、首末页与空数据状态。', 'PaginationComponentExample'),
      }),
      component('HySticky', 'hy_lists.dart', '用于 CustomScrollView.slivers 的吸顶内容。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'height', description: '吸顶高度，默认 52' },
        ],
        preview: demo('component-sticky', 'HySticky 吸顶', 'component_navigation_examples.dart', 380, '滚动列表观察标题保持在顶部。', 'StickyComponentExample'),
      }),
    ],
    conventions: [
      '`HyTabs` 与 `HyTabBarView` 应共享同一个 `TabController`，或位于同一个 `DefaultTabController`。',
      '`HyLoadMore` 需要有限高度；`onLoadMore` 必须返回完整请求 Future。',
    ],
  },
  {
    id: 'business',
    title: '复合组件',
    navTitle: '复合组件',
    description: '由基础组件组合而成的搜索、倒计时、折叠面板和时间轴，仍保持业务无关。',
    page: '/components/composites',
    demos: [
      demo('business', '业务组件组合', 'interactive_examples.dart', 850, '搜索、通知、倒计时、设置菜单、折叠面板与时间轴。'),
    ],
    components: [
      component('HyCountDown', 'hy_business.dart', '基于截止时间计算，并在应用恢复前台时校准。', {
        propsDocs: [
          { name: 'endTime', description: '截止时间' },
          { name: 'onFinished', description: '倒计时结束回调' },
          { name: 'builder', description: '自定义构建器' },
        ],
        preview: demo('component-count-down', 'HyCountDown 倒计时', 'component_composite_examples.dart', 300, '结束回调 onFinished 与自定义 builder。', 'CountDownComponentExample'),
      }),
      component('HyCollapse', 'hy_business.dart', '标题与正文组成的折叠内容。', {
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'child', description: '内容组件' },
          { name: 'initiallyExpanded', description: '初始是否展开，默认 false' },
          { name: 'onChanged', description: '展开状态变化回调' },
        ],
        preview: demo('component-collapse', 'HyCollapse 折叠面板', 'component_composite_examples.dart', 340, '展开收起与 onChanged 状态回调。', 'CollapseComponentExample'),
      }),
      component('HyTimeline / HyTimelineItem', 'hy_business.dart', '订单、物流和流程事件时间轴。', {
        propsDocs: [
          { name: 'items', description: '时间轴项列表' },
        ],
        preview: demo('component-timeline', 'HyTimeline 时间轴', 'component_composite_examples.dart', 370, '展示已完成、当前和待处理事件。', 'TimelineComponentExample'),
      }),
    ],
    conventions: ['`HyCountDown.endTime` 应由 State 或业务模型持有，避免在每次 build 时重建截止时间。'],
  },
  {
    id: 'utilities',
    title: '主题与基础设施',
    navTitle: '主题与基础设施',
    description: '语义颜色、玻璃材质、间距、圆角、动效与平台辅助工具。',
    page: '/components/utilities',
    demos: [
      demo('overview', '主题化组件概览', 'overview_example.dart', 420, '文档明暗主题会同步到 Flutter 预览。'),
    ],
    components: [
      component('HyUiTheme', '../theme/hy_ui_theme.dart', '明暗主题的 ThemeData 构造入口。', {
        preview: demo('component-ui-theme', 'HyUiTheme 主题', 'component_theme_examples.dart', 290, '并排查看明暗 ThemeData 的基础表面。', 'UiThemeComponentExample'),
      }),
      component('HyUiThemeTokens', '../theme/hy_ui_theme_tokens.dart', '组件消费的 ThemeExtension 语义令牌。', {
        preview: demo('component-ui-theme-tokens', 'HyUiThemeTokens 令牌', 'component_theme_examples.dart', 300, '查看当前主题的关键语义令牌。', 'UiThemeTokensComponentExample'),
      }),
      component('HyGlassTheme', '../theme/hy_glass_theme.dart', '玻璃表面、边缘、阴影、选中态、控件轨道与遮罩令牌。', {
        preview: demo('component-glass-theme', 'HyGlassTheme 材质令牌', 'component_theme_examples.dart', 300, '查看玻璃表面与交互状态令牌。', 'GlassThemeComponentExample'),
      }),
      component('HyUiColors', '../theme/hy_ui_colors.dart', '组件库基础色板。', {
        preview: demo('component-ui-colors', 'HyUiColors 基础色', 'component_theme_examples.dart', 280, '展示组件库默认功能色。', 'UiColorsComponentExample'),
      }),
      component('HyUiSpacing', '../theme/hy_ui_spacing.dart', '统一间距常量。', {
        preview: demo('component-ui-spacing', 'HyUiSpacing 间距', 'component_theme_examples.dart', 350, '用比例条展示基础间距刻度。', 'UiSpacingComponentExample'),
      }),
      component('HyUiRadii', '../theme/hy_ui_radii.dart', '统一圆角常量。', {
        preview: demo('component-ui-radii', 'HyUiRadii 圆角', 'component_theme_examples.dart', 280, '对比四级圆角令牌。', 'UiRadiiComponentExample'),
      }),
      component('HyUiEffects', '../theme/hy_ui_effects.dart', '玻璃模糊、阴影与选择动效常量。', {
        preview: demo('component-ui-effects', 'HyUiEffects 动效与阴影', 'component_theme_examples.dart', 280, '展示统一的表面阴影与效果参数。', 'UiEffectsComponentExample'),
      }),
      component('HyUiBuildContext', '../theme/hy_ui_context.dart', '通过 `context.hyUi` 读取主题令牌的扩展。', {
        preview: demo('component-ui-build-context', 'HyUiBuildContext 扩展', 'component_theme_examples.dart', 270, '通过 BuildContext 读取主题与材质。', 'UiBuildContextComponentExample'),
      }),
      component('HyThemeController', '../utils/hy_utils.dart', '由应用持有的主题模式与主色控制器。', {
        preview: demo('component-theme-controller', 'HyThemeController 控制器', 'component_theme_examples.dart', 270, '切换并监听主题模式状态。', 'ThemeControllerComponentExample'),
      }),
      component('HyScreen', '../utils/hy_utils.dart', '屏幕宽度、紧凑断点、dp 与 rpx 换算。', {
        preview: demo('component-screen', 'HyScreen 屏幕适配', 'component_theme_examples.dart', 310, '实时读取当前预览宽度和换算结果。', 'ScreenComponentExample'),
      }),
      component('HyKeyboard / HyRoute / HySafeArea', '../utils/hy_utils.dart', '键盘、路由和安全区常用操作。', {
        preview: demo('component-keyboard', '键盘、路由与安全区', 'component_theme_examples.dart', 320, '展示键盘收起和安全区包装。', 'KeyboardComponentExample'),
      }),
    ],
  },
];

export function getComponentGroup(id: string): ComponentGroup {
  const group = componentGroups.find((item) => item.id === id);
  if (!group) throw new Error(`Unknown component group: ${id}`);
  return group;
}

export interface ComponentDocumentEntry extends ComponentEntry {
  groupId: string;
  groupTitle: string;
}

export interface ComponentSidebarSection {
  id: string;
  title: string;
  components: ComponentDocumentEntry[];
}

export const componentEntries: ComponentDocumentEntry[] = componentGroups.flatMap((group) => (
  group.components.map((entry) => ({
    ...entry,
    groupId: group.id,
    groupTitle: group.title,
  }))
));

const listComponentIds = new Set([
  'list-tile', 'list', 'menu-list', 'slide-menu', 'pull-refresh', 'load-more', 'sticky',
]);
const actionComponentIds = new Set(['button', 'pressable']);

/** 侧栏只展示分类标题和组件叶子项，不再链接分类聚合页。 */
export const componentSidebarSections: ComponentSidebarSection[] = componentGroups.flatMap((group) => {
  const entries = componentEntries.filter((entry) => (
    entry.groupId === group.id && entry.sidebar !== false
  ));
  if (group.id === 'actions') {
    return [
      {
        id: 'actions',
        title: '操作组件',
        components: entries.filter((entry) => actionComponentIds.has(entry.id)),
      },
      {
        id: 'containers',
        title: '容器与材质',
        components: entries.filter((entry) => !actionComponentIds.has(entry.id)),
      },
    ];
  }
  if (group.id !== 'navigation') {
    return [{ id: group.id, title: group.title, components: entries }];
  }
  return [
    {
      id: 'navigation',
      title: '导航组件',
      components: entries.filter((entry) => !listComponentIds.has(entry.id)),
    },
    {
      id: 'lists',
      title: '列表组件',
      components: entries.filter((entry) => listComponentIds.has(entry.id)),
    },
  ];
});

export function getComponentEntry(id: string) {
  const entry = componentEntries.find((item) => item.id === id);
  if (!entry) throw new Error(`Unknown component document: ${id}`);
  return {
    entry,
    group: getComponentGroup(entry.groupId),
  };
}
