<template>
  <section class="hy-icon-gallery">
    <div class="hy-icon-gallery__toolbar">
      <label class="hy-icon-gallery__search">
        <svg
          class="hy-icon-gallery__search-icon"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          aria-hidden="true"
        >
          <circle cx="11" cy="11" r="8" />
          <path d="m21 21-4.3-4.3" />
        </svg>
        <input
          v-model.trim="query"
          type="search"
          placeholder="搜索图标，例如 house、arrow、share"
          autocomplete="off"
        />
      </label>
      <span class="hy-icon-gallery__count">{{ filteredIcons.length }} 个图标</span>
    </div>

    <p class="hy-icon-gallery__hint">
      点击图标复制 Flutter 引用 <code>LucideIcons.xxx</code>；图标来自
      <code>lucide_icons_flutter</code> 包（Lucide 1.46 全量 2096 个），按分类平铺。
    </p>

    <div v-if="groups.length" class="hy-icon-gallery__groups">
      <section
        v-for="group in groups"
        :key="group.category"
        class="hy-icon-gallery__group"
      >
        <h3
          :id="`category-${group.category}`"
          class="hy-icon-gallery__group-title"
        >
          <span>{{ group.label }}</span>
          <code>{{ group.icons.length }}</code>
        </h3>
        <div class="hy-icon-gallery__grid">
          <button
            v-for="item in group.icons"
            :key="item.name"
            class="hy-icon-gallery__item"
            type="button"
            :title="`复制 LucideIcons.${item.name}`"
            @click="copyIcon(item.name)"
          >
            <span class="hy-icon-gallery__glyph" :style="glyphStyle">{{ glyph(item) }}</span>
            <code>{{ item.name }}</code>
            <span v-if="copiedName === item.name" class="hy-icon-gallery__copied">已复制</span>
          </button>
        </div>
      </section>
    </div>

    <p v-else class="hy-icon-gallery__empty">当前搜索没有匹配的图标。</p>
  </section>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { lucideIcons, lucideCategoryLabels } from '../../lucide-icons-data';

const query = ref('');
const copiedName = ref('');

const allIcons = lucideIcons.map((item) => ({
  ...item,
  searchText: `${item.name} ${item.keywords}`.toLowerCase(),
}));

const filteredIcons = computed(() => {
  const keywords = query.value.toLowerCase().split(/\s+/).filter(Boolean);
  if (keywords.length === 0) return allIcons;
  return allIcons.filter((item) =>
    keywords.every((keyword) => item.searchText.includes(keyword)),
  );
});

// 按分类分组平铺；搜索时仅保留命中的分类
const groups = computed(() => {
  const map = new Map<string, typeof allIcons>();
  for (const icon of filteredIcons.value) {
    const list = map.get(icon.category) ?? [];
    list.push(icon);
    map.set(icon.category, list);
  }
  return Array.from(map.entries())
    .map(([category, icons]) => ({
      category,
      label: lucideCategoryLabels[category] || category,
      icons,
    }))
    .sort((left, right) => left.label.localeCompare(right.label, 'zh-CN'));
});

function glyph(item: { codePoint: number }) {
  return String.fromCodePoint(item.codePoint);
}

const glyphStyle = { fontFamily: 'lucide' };

async function copyIcon(name: string) {
  const text = `LucideIcons.${name}`;
  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text);
    } else {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      textarea.remove();
    }
    copiedName.value = name;
    setTimeout(() => {
      if (copiedName.value === name) copiedName.value = '';
    }, 1200);
  } catch {
    // 复制失败时静默，保留按钮 title 提示手动复制
  }
}
</script>

<style scoped>
.hy-icon-gallery {
  margin-top: 18px;
}

.hy-icon-gallery__toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.hy-icon-gallery__search {
  display: flex;
  align-items: center;
  width: min(100%, 460px);
  height: 36px;
  padding: 0 10px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  color: var(--vp-c-text-2);
  background: transparent;
  gap: 8px;
}

.hy-icon-gallery__search:focus-within {
  border-color: var(--vp-c-brand-1);
  outline: 2px solid color-mix(in srgb, var(--vp-c-brand-1) 18%, transparent);
}

.hy-icon-gallery__search-icon {
  width: 18px;
  height: 18px;
  flex: none;
}

.hy-icon-gallery__search input {
  width: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  color: var(--vp-c-text-1);
  background: transparent;
  font: inherit;
  font-size: 14px;
}

.hy-icon-gallery__count,
.hy-icon-gallery__hint,
.hy-icon-gallery__empty {
  color: var(--vp-c-text-2);
  font-size: 13px;
}

.hy-icon-gallery__count {
  white-space: nowrap;
}

.hy-icon-gallery__hint {
  margin: 12px 0;
}

.hy-icon-gallery__groups {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.hy-icon-gallery__group-title {
  display: flex;
  align-items: center;
  margin: 0 0 10px;
  font-size: 15px;
  font-weight: 600;
  gap: 8px;
  scroll-margin-top: 84px;
}

.hy-icon-gallery__group-title code {
  padding: 1px 7px;
  border-radius: 999px;
  color: var(--vp-c-text-2);
  background: var(--vp-c-default-soft);
  font-size: 11px;
  font-weight: 500;
}

.hy-icon-gallery__grid {
  position: relative;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(126px, 1fr));
  border-top: 1px solid var(--vp-c-divider);
  border-left: 1px solid var(--vp-c-divider);
}

.hy-icon-gallery__item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 0;
  min-height: 94px;
  padding: 10px 7px;
  border: 0;
  border-right: 1px solid var(--vp-c-divider);
  border-bottom: 1px solid var(--vp-c-divider);
  color: var(--vp-c-text-1);
  background: transparent;
  cursor: pointer;
  flex-direction: column;
  gap: 10px;
  transition: color 0.18s ease, background 0.18s ease;
}

.hy-icon-gallery__item:hover {
  color: var(--vp-c-brand-1);
  background: var(--vp-c-default-soft);
}

.hy-icon-gallery__glyph {
  font-size: 24px;
  line-height: 1;
  font-style: normal;
}

.hy-icon-gallery__item code {
  display: block;
  max-width: 100%;
  padding: 0;
  color: inherit;
  background: transparent;
  font-size: 11px;
  line-height: 1.35;
  overflow-wrap: anywhere;
  text-align: center;
}

.hy-icon-gallery__copied {
  position: absolute;
  top: 6px;
  right: 6px;
  padding: 1px 5px;
  border-radius: 5px;
  color: var(--vp-c-brand-1);
  background: color-mix(in srgb, var(--vp-c-brand-1) 14%, transparent);
  font-size: 10px;
  line-height: 1.4;
}

.hy-icon-gallery__empty {
  padding: 28px 0;
  text-align: center;
}

@media (max-width: 640px) {
  .hy-icon-gallery__toolbar {
    align-items: stretch;
    flex-direction: column;
  }

  .hy-icon-gallery__search {
    width: 100%;
  }

  .hy-icon-gallery__grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
