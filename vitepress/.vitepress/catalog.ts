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
  fullScreen?: boolean;
}

export interface ComponentGroup {
  id: string;
  title: string;
  navTitle: string;
  description: string;
  page: string;
  demos: ComponentDemo[];
  components: ComponentEntry[];
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
    .replace(/^Hyper/, '')
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
  'component-library',
  'Hyper UI 组件总览',
  'component_library_example.dart',
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
      component('HyperText', 'hyper_typography.dart', '统一 small、default、large 三档文字尺寸。', {
        propsDocs: [
          { name: 'data', description: '显示的文本内容' },
          { name: 'size', description: '文字尺寸：small / default / large，默认 default' },
          { name: 'color', description: '文字颜色' },
          { name: 'weight', description: '字重' },
          { name: 'maxLines', description: '最大行数' },
          { name: 'textAlign', description: '文字对齐方式' },
        ],
        preview: demo('component-text', 'HyperText 文字层级', 'component_foundation_examples.dart', 480, '三种文字尺寸与颜色、字重、行数截断。', 'TextComponentExample'),
      }),
      component('HyperIcon / HyperIcons', 'hyper_typography.dart', '统一的图标组件与常用业务图标集合。', {
        propsDocs: [
          { name: 'icon', description: '图标数据，IconData 类型' },
          { name: 'size', description: '图标大小，默认 24' },
          { name: 'color', description: '图标颜色' },
        ],
        preview: demo('component-icon', 'HyperIcon 图标', 'component_foundation_examples.dart', 340, '常用语义图标、尺寸与颜色。', 'IconComponentExample'),
      }),
      component('HyperImage', 'hyper_image.dart', '支持 ImageProvider、网络、资源、占位、失败态与缩放预览。', {
        propsDocs: [
          { name: 'type', description: '数据源类型：provider / network / asset，默认 provider' },
          { name: 'provider', description: '图片数据源，ImageProvider 类型' },
          { name: 'source', description: 'network 类型的 URL 或 asset 类型的资源路径' },
          { name: 'width', description: '图片宽度' },
          { name: 'height', description: '图片高度' },
          { name: 'radius', description: '圆角大小，默认 16' },
          { name: 'fit', description: '图片适配方式，默认 BoxFit.cover' },
          { name: 'placeholder', description: '加载中占位组件' },
          { name: 'errorPlaceholder', description: '加载失败占位组件' },
          { name: 'preview', description: '是否点击进入全屏预览，默认 false' },
        ],
        preview: demo('component-image', 'HyperImage 图片', 'component_foundation_examples.dart', 480, '网络图片点击预览、加载占位与失败兜底。', 'ImageComponentExample'),
      }),
      component('HyperAvatar', 'hyper_image.dart', '图片、文字或默认图标头像，支持圆形和自定义圆角。', {
        propsDocs: [
          { name: 'image', description: '头像图片数据源，ImageProvider 类型' },
          { name: 'text', description: '文字头像内容' },
          { name: 'size', description: '头像尺寸，默认 40' },
          { name: 'radius', description: '圆角大小，为空时为圆形' },
          { name: 'color', description: '文字或默认图标颜色' },
          { name: 'backgroundColor', description: '背景颜色' },
        ],
        preview: demo('component-avatar', 'HyperAvatar 头像', 'component_foundation_examples.dart', 380, '文字头像、尺寸、圆角与背景色。', 'AvatarComponentExample'),
      }),
      component('HyperBadge', 'hyper_badge.dart', '状态、可交互标签与数字角标共用的徽标。', {
        propsDocs: [
          { name: 'type', description: '形态：status / tag / count，默认 status' },
          { name: 'label', description: '徽标文字' },
          { name: 'tone', description: '语义色调；count 类型默认为错误色' },
          { name: 'color', description: '覆盖徽标颜色' },
          { name: 'icon', description: '前置图标' },
          { name: 'subtle', description: '状态徽标是否使用弱化样式，默认 true' },
          { name: 'selected', description: 'tag 类型的选中态' },
          { name: 'onTap / onClose', description: 'tag 类型的点击与移除回调' },
          { name: 'child / count / max / dot / showZero', description: 'count 类型的角标内容与显示规则' },
        ],
        preview: demo('component-badge', 'HyperBadge 徽标', 'component_foundation_examples.dart', 700, '状态、数字角标、可选择与可移除标签。', 'BadgeComponentExample'),
      }),
      component('HyperUiTone / HyperUiToneResolver', 'hyper_tone.dart', '跨组件共用的语义状态及其主题颜色解析扩展。', {
        sidebar: false,
        preview: demo('component-ui-tone', 'HyperUiTone 语义色', 'component_foundation_examples.dart', 300, '五种跨组件语义状态与说明。', 'ToneComponentExample'),
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
      component('HyperButton', 'hyper_button.dart', '通过 type 统一提供 filled、tonal、outline、ghost、danger 五种视觉层级，并支持加载、禁用、图标按钮和通栏状态。', {
        propsDocs: [
          { name: 'label', description: '按钮文字；省略时配合 icon 自动呈现方形图标按钮' },
          { name: 'onPressed', description: '点击回调；为 null 时按钮进入禁用态' },
          { name: 'type', description: '视觉类型：filled / tonal / outline / ghost / danger，默认 filled' },
          { name: 'size', description: '尺寸：small / default / large，默认 default' },
          { name: 'icon', description: '前置图标；label 省略时切换为图标按钮' },
          { name: 'trailingIcon', description: '后置图标' },
          { name: 'loading', description: '是否显示加载态，默认 false；加载期间禁止点击' },
          { name: 'expanded', description: '是否通栏铺满，默认 false；不传时按内容收缩（等价 inline-block）' },
          { name: 'tooltip', description: '悬停或长按提示文字' },
          { name: 'color', description: '覆盖前景色，图标按钮可直接指定图标颜色' },
          { name: 'backgroundColor', description: '覆盖按钮背景色，图标按钮默认使用玻璃表面' },
        ],
        preview: demo('component-button', 'HyperButton 状态', 'buttons_example.dart', 360, '展示按钮层级、尺寸、状态、图标按钮与宽度表现。'),
      }),
      component('HyperCard', 'hyper_card.dart', '具有标题、操作区、正文、底部和选中态的内容容器。', {
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
        ],
        preview: demo('component-card', 'HyperCard 结构', 'component_surface_examples.dart', 560, '完整结构、选中态与无标题纯内容。', 'CardComponentExample'),
      }),
      component('HyperPressable', 'hyper_pressable.dart', '按下即响应、可适配减少动画的通用触控反馈层。', {
        propsDocs: [
          { name: 'child', description: '子组件' },
          { name: 'onPressed', description: '点击回调' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'pressedScale', description: '按下时缩放比例，默认 0.975' },
          { name: 'pressedOpacity', description: '按下时透明度，默认 0.92' },
          { name: 'borderRadius', description: '圆角' },
        ],
        preview: demo('component-pressable', 'HyperPressable 按压反馈', 'component_action_examples.dart', 280, '按住表面感受即时缩放与透明度反馈。', 'PressableComponentExample'),
      }),
    ],
  },
  {
    id: 'layout',
    title: '布局组件',
    navTitle: '布局组件',
    description: '分割、动态骨架与空状态。',
    page: '/components/layout',
    demos: [
      demo('layout', '布局容器与占位状态', 'complete_examples.dart', 740),
    ],
    components: [
      component('HyperPageContentSliver', 'hyper_page_content.dart', '页面内容 sliver：统一内容边距，宽屏（桌面/平板）下居中限宽，手机端占满。可放入 CustomScrollView。', {
        propsDocs: [
          { name: 'child', description: '页面内容' },
          { name: 'padding', description: '内容区边距，默认 EdgeInsets.fromLTRB(16, 12, 16, 40)' },
          { name: 'maxWidth', description: '宽屏下居中内容的最大宽度，默认 800；手机端屏幕更窄时不生效' },
        ],
        preview: demo('component-page-content-sliver', 'HyperPageContentSliver 页面内容', 'component_layout_examples.dart', 380, '统一边距与宽屏居中限宽。', 'PageContentComponentExample'),
      }),
      component('HyperDivider', 'hyper_layout.dart', '横向或纵向、实线或虚线分隔。', {
        propsDocs: [
          { name: 'axis', description: '方向，默认 Axis.horizontal' },
          { name: 'indent', description: '起始缩进，默认 0' },
          { name: 'endIndent', description: '结束缩进，默认 0' },
          { name: 'type', description: '线条类型：solid / dashed，默认 solid' },
          { name: 'length', description: '长度' },
          { name: 'color', description: '颜色' },
        ],
        preview: demo('component-divider', 'HyperDivider 分割线', 'component_layout_examples.dart', 300, '实线、虚线、缩进与纵向分隔。', 'DividerComponentExample'),
      }),
      component('HyperSkeleton', 'hyper_layout.dart', '适配减少动画设置的列表或卡片扫光占位。', {
        propsDocs: [
          { name: 'rows', description: '骨架行数，默认 3' },
          { name: 'type', description: '骨架类型：text / card，默认 text' },
        ],
        preview: demo('component-skeleton', 'HyperSkeleton 骨架屏', 'component_feedback_examples.dart', 500, '卡片骨架与列表骨架两种形态。', 'SkeletonComponentExample'),
      }),
      component('HyperEmptyState', 'hyper_empty_state.dart', '包含图标、标题、说明和操作的空状态。', {
        propsDocs: [
          { name: 'icon', description: '图标，IconData 类型' },
          { name: 'title', description: '标题' },
          { name: 'message', description: '说明文字' },
          { name: 'action', description: '操作按钮组件' },
        ],
        preview: demo('component-empty-state', 'HyperEmptyState 空状态', 'component_layout_examples.dart', 420, '带恢复操作与纯提示两种空状态。', 'EmptyStateComponentExample'),
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
      component('HyperTextField', 'hyper_text_field.dart', '纯文本输入控件：支持单行/多行、密码、清空、前后缀插槽、字数统计与错误态，默认不带标题和图标。', {
        propsDocs: [
          { name: 'controller', description: '文本编辑控制器，为空时按 initialValue 内部维护' },
          { name: 'focusNode', description: '焦点节点' },
          { name: 'hintText', description: '占位提示文字' },
          { name: 'errorText', description: '错误提示文字，传入即为错误态' },
          { name: 'prefix', description: '前缀插槽，可放置图标等任意组件' },
          { name: 'suffix', description: '后缀插槽，可放置任意组件' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'readOnly', description: '是否只读，默认 false' },
          { name: 'type', description: '输入类型：text / search / password / textarea，默认 text' },
          { name: 'size', description: '尺寸：small / default / large，默认 default' },
          { name: 'color', description: '输入文字颜色' },
          { name: 'showPasswordToggle', description: '是否显示密码显隐按钮，默认 false' },
          { name: 'clearable', description: '是否显示清空按钮，默认 false' },
          { name: 'rows', description: 'textarea 的可见行数，默认 3' },
          { name: 'maxLength', description: '最大字符数，超出阻止输入' },
          { name: 'showWordLimit', description: '是否显示字符计数，需配合 maxLength，默认 false' },
          { name: 'autofocus', description: '是否自动获取焦点，默认 false' },
          { name: 'keyboardType', description: '键盘类型' },
          { name: 'textInputAction', description: '键盘动作按钮类型' },
          { name: 'onChanged', description: '内容变化回调' },
          { name: 'onSubmitted', description: '提交回调' },
          { name: 'validator', description: '表单校验函数' },
          { name: 'initialValue', description: '无 controller 时的初始值' },
        ],
        preview: demo('component-text-field', 'HyperTextField 输入框', 'component_form_examples.dart', 860, '展示基础、清空、密码、前后缀、多行、计数、禁用只读与错误态。', 'TextFieldComponentExample'),
      }),
      component('HyperFormField', 'hyper_form_field.dart', '为任意输入控件统一排列标题、必填标记、辅助文案和错误提示。', {
        propsDocs: [
          { name: 'label', description: '字段标题' },
          { name: 'child', description: '输入控件' },
          { name: 'helperText', description: '正常状态辅助说明' },
          { name: 'errorText', description: '错误提示，存在时替代辅助说明' },
          { name: 'isRequired', description: '是否显示必填标记，默认 false' },
          { name: 'trailing', description: '标题右侧附加组件' },
        ],
        preview: demo('component-form-field', 'HyperFormField 字段容器', 'component_form_field_example.dart', 360, '文本输入与数值控件共享标题、说明和错误层级。', 'FormFieldComponentExample'),
      }),
      component('HyperSegmentedControl / HyperSegmentOption', 'hyper_segmented_control.dart', '适用于少量互斥选项的受控分段选择。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'selectedValue', description: '当前选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'equalWidth', description: '是否等宽，默认 true' },
        ],
        preview: demo('component-segmented-control', 'HyperSegmentedControl 分段选择', 'component_form_examples.dart', 500, '受控切换、非等宽布局、图标选项与禁用项。', 'SegmentedControlComponentExample'),
      }),
      component('HyperSelect / HyperOption', 'hyper_select.dart', '底部弹层单选或多选，支持禁用项。', {
        propsDocs: [
          { name: 'type', description: '选择类型：single / multiple，默认 single' },
          { name: 'options', description: '选项列表' },
          { name: 'values', description: '已选中值列表' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'placeholder', description: '占位文字，默认 请选择' },
          { name: 'label', description: '选择框上方的字段标题' },
        ],
        preview: demo('component-select', 'HyperSelect 底部选择', 'component_form_examples.dart', 480, '单选、多选、禁用项与占位文案。', 'SelectComponentExample'),
      }),
      component('HyperDropdown', 'hyper_dropdown.dart', '锚定触发器展开、适合在选择时保持页面上下文的泛型下拉。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'value', description: '当前选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'label', description: '选择框上方的字段标题' },
          { name: 'placeholder', description: '占位文字，默认 请选择' },
          { name: 'menuMaxHeight', description: '下拉菜单最大高度，默认 320' },
          { name: 'width', description: '宽度' },
        ],
        preview: demo('component-dropdown', 'HyperDropdown 下拉菜单', 'component_form_examples.dart', 420, '带标签单选、占位与禁用项、固定宽度与菜单高度。', 'DropdownComponentExample'),
      }),
      component('HyperCheckbox', 'hyper_selection_controls.dart', '支持三态、禁用和标签的受控复选。', {
        propsDocs: [
          { name: 'value', description: '是否选中' },
          { name: 'onChanged', description: '状态变化回调' },
          { name: 'label', description: '标签文字' },
          { name: 'tristate', description: '是否三态，默认 false' },
        ],
        preview: demo('component-checkbox', 'HyperCheckbox 复选框', 'component_form_examples.dart', 520, '受控复选、三态、禁用与无标签纯控件。', 'CheckboxComponentExample'),
      }),
      component('HyperRadio', 'hyper_selection_controls.dart', '泛型值受控单选。', {
        propsDocs: [
          { name: 'value', description: '当前选项值' },
          { name: 'groupValue', description: '组选中值' },
          { name: 'onChanged', description: '选中变化回调' },
          { name: 'label', description: '标签文字' },
        ],
        preview: demo('component-radio', 'HyperRadio 单选框', 'component_form_examples.dart', 420, '互斥单选组与禁用项。', 'RadioComponentExample'),
      }),
      component('HyperSwitch', 'hyper_selection_controls.dart', '布尔值受控开关。', {
        propsDocs: [
          { name: 'value', description: '是否开启' },
          { name: 'onChanged', description: '状态变化回调' },
          { name: 'label', description: '标签文字' },
        ],
        preview: demo('component-switch', 'HyperSwitch 开关', 'component_form_examples.dart', 500, '受控开关、禁用与无标签纯控件。', 'SwitchComponentExample'),
      }),
      component('HyperSlider', 'hyper_selection_controls.dart', '范围、分段和结束回调可配置的滑块。', {
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
        preview: demo('component-slider', 'HyperSlider 滑块', 'component_form_examples.dart', 560, '连续取值、离散分段、自定义范围与提交回调。', 'SliderComponentExample'),
      }),
      component('HyperNumberStepper', 'hyper_number_stepper.dart', '用于整数数量的紧凑受控增减器，支持上下限和步长。', {
        propsDocs: [
          { name: 'value', description: '当前整数值，需处于上下限范围内' },
          { name: 'onChanged', description: '值变化回调；为空时只读' },
          { name: 'min', description: '最小值，默认 0' },
          { name: 'max', description: '最大值，默认 99' },
          { name: 'step', description: '每次增减的步长，默认 1' },
        ],
        preview: demo('component-number-stepper', 'HyperNumberStepper 数值步进', 'component_number_stepper_example.dart', 330, '数量、步长、边界与只读状态。', 'NumberStepperComponentExample'),
      }),
      component('HyperPicker', 'hyper_picker.dart', '通过滚轮完成普通选项选择。', {
        propsDocs: [
          { name: 'options', description: '选项列表' },
          { name: 'initialIndex', description: '初始选中索引，默认 0' },
          { name: 'title', description: '标题，默认 选择选项' },
        ],
        preview: demo('component-picker', 'HyperPicker 滚轮选择器', 'component_form_examples.dart', 420, '基础滚轮选择与指定初始项。', 'PickerComponentExample'),
      }),
      component('HyperDatePicker / HyperTimeOfDay / HyperDateRange', 'hyper_date_picker.dart', '在玻璃底部弹层中通过月历选择日期或区间，时间单独使用滚轮。', {
        propsDocs: [
          { name: 'initialDate', description: '初始日期' },
          { name: 'initialTime', description: '初始时间' },
          { name: 'initialRange', description: '初始日期区间' },
          { name: 'firstDate', description: '最早可选日期' },
          { name: 'lastDate', description: '最晚可选日期' },
        ],
        preview: demo('component-date-picker', 'HyperDatePicker 月历选择', 'component_form_examples.dart', 500, '月历单日与区间选择、时间选择。', 'DatePickerComponentExample'),
      }),
      component('HyperUploader / HyperUploadSource / HyperUploadStatus / HyperUploadFile / HyperUploadCancellation / HyperUploadItem', 'hyper_uploader.dart', '通过注入式适配器完成选择、上传、进度、取消、失败与重试。', {
        propsDocs: [
          { name: 'pick', description: '文件选择器，HyperFilePicker 类型' },
          { name: 'upload', description: '文件上传器，HyperFileUpload 类型' },
          { name: 'onChanged', description: '上传列表变化回调' },
          { name: 'onError', description: '错误回调' },
          { name: 'initialItems', description: '初始上传项列表，默认空数组' },
          { name: 'maxCount', description: '最大文件数，默认 9' },
          { name: 'maxBytes', description: '单文件最大字节数，默认 10MB' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'sources', description: '可选上传来源，默认相册和相机' },
        ],
        preview: demo('component-uploader', 'HyperUploader 上传', 'upload_example.dart', 680, '文件选择、进度、取消、重试与禁用状态。'),
      }),
      component('HyperFilePicker / HyperFileUpload', 'hyper_uploader.dart', '由业务层实现的文件选择与上传函数类型。', {
        sidebar: false,
        preview: demo('component-file-picker', '文件能力注入', 'component_form_examples.dart', 280, '说明选择器与上传器的职责边界。', 'FilePickerComponentExample'),
      }),
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
      component('HyperToast', 'hyper_feedback.dart', '支持语义色和可选撤销动作的玻璃轻提示。', {
        propsDocs: [
          { name: 'type', description: '状态类型：neutral / primary / success / warning / error / info，默认 neutral' },
          { name: 'color', description: '覆盖提示颜色' },
          { name: 'duration', description: '显示时长，默认 2 秒' },
          { name: 'actionLabel', description: '操作按钮文字' },
          { name: 'onAction', description: '操作按钮回调' },
        ],
        preview: demo('component-toast', 'HyperToast 轻提示', 'component_feedback_examples.dart', 380, '四种语义色调、操作按钮与显示时长。', 'ToastComponentExample'),
      }),
      component('HyperDialog', 'hyper_feedback.dart', '确认、提示或自定义正文对话框。', {
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'message', description: '提示文字' },
          { name: 'content', description: '自定义正文组件' },
          { name: 'confirmLabel', description: '确认按钮文字，默认 确定' },
          { name: 'cancelLabel', description: '取消按钮文字，默认 取消' },
          { name: 'type', description: '确认按钮类型：default / danger，默认 default' },
          { name: 'showCancel', description: '是否显示取消按钮，默认 true' },
        ],
        preview: demo('component-dialog', 'HyperDialog 对话框', 'component_feedback_examples.dart', 420, '标准确认、危险操作、仅确认按钮与自定义正文。', 'DialogComponentExample'),
      }),
      component('HyperLoading', 'hyper_feedback.dart', '局部加载状态与自动清理的全局任务遮罩。', {
        propsDocs: [
          { name: 'label', description: '加载提示文字' },
          { name: 'size', description: '加载图标大小，默认 24' },
        ],
        preview: demo('component-loading', 'HyperLoading 加载', 'component_feedback_examples.dart', 420, '局部加载（尺寸与文案）与全局任务遮罩。', 'LoadingComponentExample'),
      }),
      component('HyperDrawer / HyperDrawerPlacement', 'hyper_drawer.dart', '支持双侧弹出、RTL、自定义宽度、固定底部操作区与泛型返回结果的柔光抽屉。', {
        propsDocs: [
          { name: 'child', description: '内容组件' },
          { name: 'title', description: '标题' },
          { name: 'footer', description: '底部操作区组件' },
          { name: 'onClose', description: '关闭回调' },
          { name: 'scrollable', description: '是否可滚动，默认 true' },
          { name: 'padding', description: '内边距' },
        ],
        preview: demo('component-drawer', 'HyperDrawer 抽屉', 'component_feedback_examples.dart', 460, '右侧抽屉返回值、左侧抽屉与底部操作区。', 'DrawerComponentExample'),
      }),
      component('HyperActionSheet / HyperAction', 'hyper_action_sheet.dart', '统一的自定义底部弹层与操作菜单，支持危险项和禁用项。', {
        propsDocs: [
          { name: 'builder', description: '自定义内容构建器，与 actions 二选一' },
          { name: 'actions', description: '操作项列表' },
          { name: 'HyperAction.type', description: '操作类型：default / danger，默认 default' },
          { name: 'title', description: '标题' },
          { name: 'dismissible', description: '是否可点击外部关闭，默认 true' },
          { name: 'cancelLabel', description: '取消按钮文字，默认 取消' },
        ],
        preview: demo('component-action-sheet', 'HyperActionSheet 底部弹层', 'component_feedback_examples.dart', 420, '自定义内容、操作列表与不可点外关闭的弹层。', 'ActionSheetComponentExample'),
      }),
      component('HyperPopover', 'hyper_popover.dart', '锚定子组件的补充说明气泡。', {
        propsDocs: [
          { name: 'child', description: '锚点子组件' },
          { name: 'content', description: '气泡内容组件' },
        ],
        preview: demo('component-popover', 'HyperPopover 气泡', 'component_feedback_examples.dart', 260, '点击锚点查看补充说明。', 'PopoverComponentExample'),
      }),
      component('HyperTooltip', 'hyper_tooltip.dart', '悬停、长按或键盘聚焦时出现的轻量玻璃提示。', {
        propsDocs: [
          { name: 'message', description: '提示文字' },
          { name: 'child', description: '锚点组件' },
          { name: 'hoverDelay', description: '悬停显示延迟，默认 500 毫秒' },
          { name: 'maxWidth', description: '提示最大宽度，默认 240' },
        ],
        preview: demo('component-tooltip', 'HyperTooltip 轻提示', 'component_tooltip_example.dart', 260, '悬停、长按与键盘聚焦。', 'TooltipComponentExample'),
      }),
      component('HyperPopupMenu', 'hyper_popover.dart', '基于 HyperAction 的泛型弹出菜单。', {
        propsDocs: [
          { name: 'actions', description: '菜单项列表' },
          { name: 'onSelected', description: '选中回调' },
          { name: 'icon', description: '触发图标，默认 LucideIcons.ellipsis' },
          { name: 'tooltip', description: '长按提示文字，默认 更多操作' },
        ],
        preview: demo('component-popup-menu', 'HyperPopupMenu 弹出菜单', 'component_feedback_examples.dart', 260, '选择菜单项并读取泛型返回值。', 'PopupMenuComponentExample'),
      }),
      component('HyperNoticeBar', 'hyper_notice_bar.dart', '短公告静止、长公告滚动的可关闭通知条。', {
        propsDocs: [
          { name: 'message', description: '公告内容' },
          { name: 'onTap', description: '点击回调' },
          { name: 'onClose', description: '关闭回调' },
          { name: 'speed', description: '滚动速度，默认 28' },
        ],
        preview: demo('component-notice-bar', 'HyperNoticeBar 公告栏', 'component_feedback_examples.dart', 400, '短公告静止、长公告滚动与关闭。', 'NoticeBarComponentExample'),
      }),
    ],
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
      component('HyperNavBar', 'hyper_nav_bar.dart', '默认 44px、标题靠左的透明导航容器；所有内容使用 Widget 插槽，也可接管整行布局。', {
        id: 'nav-bar',
        navName: 'HyperNavBar',
        propsDocs: [
          { name: 'title', description: '可选主内容 Widget 插槽，不限于文字；默认提供可覆盖的标题文字样式' },
          { name: 'subtitle', description: '可选副内容 Widget 插槽，不强制行数或溢出处理' },
          { name: 'leading', description: '可选前导 Widget，未提供时可自动显示返回按钮' },
          { name: 'trailing', description: '完整尾部 Widget 插槽，与 actions 二选一' },
          { name: 'actions', description: '操作区组件列表，默认空数组' },
          { name: 'child', description: '完整内部布局 Widget，与其他内容插槽互斥，不生成自动返回按钮' },
          { name: 'padding', description: '内容边距，默认左右 16px，可设置 EdgeInsets.zero' },
          { name: 'safeArea', description: '是否适配安全区，默认 true' },
          { name: 'automaticallyImplyLeading', description: '是否自动添加返回按钮，默认 true' },
          { name: 'centerTitle', description: '主内容是否按整栏居中，默认 false（从起始侧排列）' },
          { name: 'height', description: '导航内容高度，默认 44，不含顶部安全区' },
        ],
        preview: { ...demo('component-nav-bar', '透明导航栏', 'component_nav_bar_example.dart', 680, '在手机屏幕内滚动正文，观察导航栏保持固定。', 'NavBarComponentExample'), fullScreen: true },
      }),
      component('HyperTabBar / HyperTabItem', 'hyper_tab_bar.dart', '透明水珠按压与拖动放大、绿色选中态、释放吸附的悬浮底栏。', {
        propsDocs: [
          { name: 'items', description: '导航项列表' },
          { name: 'selectedIndex', description: '当前选中索引' },
          { name: 'onSelected', description: '选中回调' },
          { name: 'safeArea', description: '是否适配安全区，默认 true' },
          { name: 'color', description: '选中图文颜色，默认主题强调色' },
          { name: 'margin', description: '外边距' },
        ],
        preview: demo('component-tab-bar', 'HyperTabBar 底部导航', 'component_navigation_examples.dart', 320, '长按并拖动，观察水珠放大、跟手和收回。', 'TabBarComponentExample'),
      }),
      component('HyperTabs', 'hyper_navigation.dart', '与 HyperTabView 共享控制器的玻璃标签栏。', {
        propsDocs: [
          { name: 'tabs', description: '标签组件列表' },
          { name: 'pages', description: '可选页面组件列表；提供后自动管理页面切换' },
          { name: 'pageHeight', description: '页面区域高度，默认 180' },
          { name: 'initialIndex', description: '初始标签索引，默认 0' },
          { name: 'selectedIndex', description: '受控标签索引' },
          { name: 'scrollable', description: '标签是否可滚动，默认 false' },
          { name: 'onChanged', description: '标签变化回调' },
        ],
        preview: demo('component-tabs', 'HyperTabs 标签页', 'component_navigation_examples.dart', 350, '点击标签或横向滑动页面。', 'TabsComponentExample'),
      }),
      component('HyperCarousel', 'hyper_carousel.dart', '支持滑动、可选自动播放和页码回调的紧凑轮播。', {
        propsDocs: [
          { name: 'items', description: '轮播页面，至少一个' },
          { name: 'height', description: '页面高度，默认 180' },
          { name: 'initialIndex', description: '初始页索引，默认 0' },
          { name: 'onPageChanged', description: '页面变化回调' },
          { name: 'showIndicator', description: '是否显示页码指示器，默认 true' },
          { name: 'autoPlayInterval', description: '自动播放间隔，需大于 350 毫秒；为空时不自动播放' },
        ],
        preview: demo('component-carousel', 'HyperCarousel 轮播', 'component_carousel_example.dart', 280, '滑动切页与页码同步。', 'CarouselComponentExample'),
      }),
      component('HyperPageIndicator', 'hyper_carousel.dart', '可独立使用的受控页码指示器。', {
        propsDocs: [
          { name: 'count', description: '总页数，必须大于 0' },
          { name: 'index', description: '当前页索引，从 0 开始' },
          { name: 'onSelected', description: '点击页码回调；为空时只读' },
        ],
        preview: demo('component-page-indicator', 'HyperPageIndicator 页码指示', 'component_carousel_example.dart', 200, '可点击与只读状态。', 'PageIndicatorComponentExample'),
      }),
      component('HyperSteps / HyperStep', 'hyper_navigation.dart', '横向或纵向步骤状态。', {
        propsDocs: [
          { name: 'steps', description: '步骤项列表' },
          { name: 'current', description: '当前步骤索引' },
          { name: 'type', description: '排列类型：horizontal / vertical，默认 horizontal' },
        ],
        preview: demo('component-steps', 'HyperSteps 步骤', 'component_navigation_examples.dart', 420, '水平受控步骤与纵向步骤（可带副标题）。', 'StepsComponentExample'),
      }),
      component('HyperProgress', 'hyper_navigation.dart', '线性、环形、确定或不定进度。', {
        propsDocs: [
          { name: 'value', description: '进度值（0-1），为空时为不定进度' },
          { name: 'type', description: '进度形态：linear / circular，默认 linear' },
          { name: 'size', description: '尺寸：small / default / large，默认 default' },
          { name: 'showLabel', description: '是否显示百分比文字，默认 true' },
          { name: 'color', description: '进度颜色' },
          { name: 'backgroundColor', description: '轨道颜色' },
        ],
        preview: demo('component-progress', 'HyperProgress 进度', 'component_navigation_examples.dart', 360, '线性粗细、环形和不定进度。', 'ProgressComponentExample'),
      }),
      component('HyperListTile', 'hyper_list_tile.dart', '支持图标、头像、标签、元信息和自定义尾部的列表项。', {
        propsDocs: [
          { name: 'type', description: '表面类型：auto / plain / glass，默认 auto' },
          { name: 'title', description: '标题' },
          { name: 'subtitle', description: '副标题' },
          { name: 'meta', description: '元信息文字' },
          { name: 'leading', description: '前置组件' },
          { name: 'leadingIcon', description: '前置图标' },
          { name: 'leadingColor', description: '前置图标颜色' },
          { name: 'trailing', description: '尾部组件' },
          { name: 'onTap', description: '点击回调' },
          { name: 'selected', description: '是否选中，默认 false' },
          { name: 'enabled', description: '是否启用，默认 true' },
          { name: 'showChevron', description: '是否显示右箭头，默认 true' },
        ],
        preview: demo('component-list-tile', 'HyperListTile 列表项', 'component_navigation_examples.dart', 400, '基础、选中/禁用与自定义插槽（showChevron）。', 'ListTileComponentExample'),
      }),
      component('HyperMenuGroup', 'hyper_lists.dart', '设置页、个人中心和详情页通用的玻璃分组菜单。', {
        propsDocs: [
          { name: 'children', description: 'HyperListTile 等分组内容' },
          { name: 'title', description: '分组标题' },
          { name: 'subtitle', description: '分组副标题' },
        ],
        preview: demo('component-menu-group', 'HyperMenuGroup 分组菜单', 'component_navigation_examples.dart', 420, '只展示设置页式分组菜单。', 'MenuGroupComponentExample'),
      }),
      component('HyperSlideMenu / HyperSlideAction', 'hyper_slide_menu.dart', '支持 RTL、速度投影、弹簧吸附与边界阻尼的侧滑菜单。', {
        propsDocs: [
          { name: 'child', description: '内容组件' },
          { name: 'startActions', description: '左侧操作列表，默认空数组' },
          { name: 'endActions', description: '右侧操作列表，默认空数组' },
          { name: 'HyperSlideAction.type', description: '操作类型：default / danger，默认 default' },
          { name: 'actionExtent', description: '操作区域宽度，默认 64' },
          { name: 'radius', description: '圆角大小，默认 18' },
          { name: 'enabled', description: '是否启用侧滑，默认 true' },
          { name: 'decorateChild', description: '是否为内容添加材质装饰，默认 true' },
        ],
        preview: demo('component-slide-menu', 'HyperSlideMenu 侧滑菜单', 'component_navigation_examples.dart', 300, '左右拖动列表行查看快捷操作。', 'SlideMenuComponentExample'),
      }),
      component('HyperPagination', 'hyper_pagination.dart', '支持跳页、省略号和 RTL 的受控分页导航。', {
        propsDocs: [
          { name: 'page', description: '当前页，从 1 开始；空数据时为 0' },
          { name: 'pageCount', description: '总页数；无数据时传 0' },
          { name: 'onChanged', description: '页码变化回调；为空时只读' },
          { name: 'maxVisiblePages', description: '中间可见页码数，默认 5' },
        ],
        preview: demo('component-pagination', 'HyperPagination 分页导航', 'component_pagination_example.dart', 260, '跳页、首末页与空数据状态。', 'PaginationComponentExample'),
      }),
    ],
  },
  {
    id: 'business',
    title: '复合组件',
    navTitle: '复合组件',
    description: '由基础组件组合而成的搜索、折叠面板和时间轴，仍保持业务无关。',
    page: '/components/composites',
    demos: [
      demo('business', '业务组件组合', 'interactive_examples.dart', 850, '搜索、通知、设置菜单、折叠面板与时间轴。'),
    ],
    components: [
            component('HyperCollapse', 'hyper_business.dart', '标题与正文组成的折叠内容。', {
        propsDocs: [
          { name: 'title', description: '标题' },
          { name: 'child', description: '内容组件' },
          { name: 'initiallyExpanded', description: '初始是否展开，默认 false' },
          { name: 'onChanged', description: '展开状态变化回调' },
        ],
        preview: demo('component-collapse', 'HyperCollapse 折叠面板', 'component_composite_examples.dart', 340, '展开收起与 onChanged 状态回调。', 'CollapseComponentExample'),
      }),
      component('HyperTimeline / HyperTimelineItem', 'hyper_business.dart', '订单、物流和流程事件时间轴。', {
        propsDocs: [
          { name: 'items', description: '时间轴项列表' },
        ],
        preview: demo('component-timeline', 'HyperTimeline 时间轴', 'component_composite_examples.dart', 370, '展示已完成、当前和待处理事件。', 'TimelineComponentExample'),
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
  'list-tile', 'list', 'menu-list', 'slide-menu',
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
