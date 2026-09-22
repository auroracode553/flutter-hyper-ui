/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_HY_UI_PREVIEW_MODE?: 'dev-server';
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
