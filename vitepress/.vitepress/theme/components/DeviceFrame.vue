<script setup lang="ts">
defineProps<{
  mode: 'fluid' | 'mobile';
}>();
</script>

<template>
  <div class="device-frame" :class="`device-frame--${mode}`">
    <!-- PC 窗口：标题栏 -->
    <div v-if="mode === 'fluid'" class="device-frame__chrome">
      <span class="device-frame__dot device-frame__dot--red" />
      <span class="device-frame__dot device-frame__dot--yellow" />
      <span class="device-frame__dot device-frame__dot--green" />
      <span class="device-frame__url" />
    </div>

    <!-- 手机：灵动岛 + 摄像头（悬浮覆盖在屏幕上） -->
    <template v-else>
      <div class="device-frame__notch">
        <span class="device-frame__camera" />
      </div>
    </template>

    <div class="device-frame__screen">
      <slot />
    </div>
  </div>
</template>
