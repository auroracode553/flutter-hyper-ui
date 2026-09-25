{{flutter_js}}
{{flutter_build_config}}

// 唯一宿主接口；脚本加载时不自动启动，避免覆盖文档页面。
window.hyUiPreviewBundle = (() => {
  let appPromise;
  return {
    protocolVersion: 2,
    start(assetBase, options = {}) {
      if (appPromise) return appPromise;
      const base = new URL(assetBase, document.baseURI).href;
      appPromise = new Promise((resolve, reject) => {
        // Flutter AMD 调试入口中的 require.js 使用 document.baseURI 解析后续脚本。
        // 文档页路径是 /components/...，临时切换到 Flutter 资源根目录可避免
        // 首屏把 /components/require.js 错误地请求成 HTML。
        const previousBase = document.querySelector('base');
        const temporaryBase = document.createElement('base');
        temporaryBase.href = base;
        document.head.prepend(temporaryBase);
        const restoreDocumentBase = () => {
          temporaryBase.remove();
          if (previousBase) document.head.prepend(previousBase);
        };
        // 回调式加载器不会将入口脚本及调试模块的错误交给 load() Promise。
        const onPreviewError = (event) => {
          const source = event.target instanceof HTMLScriptElement
            ? event.target.src : event.filename;
          if (source?.startsWith(base)) {
            finish(reject, new Error(`${event.message || '预览脚本加载失败'}：${source}`));
          }
        };
        const finish = (callback, value) => {
          window.removeEventListener('error', onPreviewError, true);
          restoreDocumentBase();
          callback(value);
        };
        window.addEventListener('error', onPreviewError, true);
        const builds = _flutter.buildConfig?.builds || [];
        if (!options.allowDebug && !builds.some((build) => build.compileTarget === 'dart2js')) {
          finish(reject, new Error('此预览仅接收标准 Flutter Web release 构建，不接收 flutter run 调试产物。'));
          return;
        }
        const config = {
          entrypointBaseUrl: base,
          assetBase: base,
          canvasKitBaseUrl: new URL('canvaskit/', base).href,
          // Chromium 使用体积更小的专用构建，其余浏览器自动回退 full。
          canvasKitVariant: 'auto',
          renderer: 'canvaskit',
          multiViewEnabled: true,
        };
        Promise.resolve().then(() => _flutter.loader.load({
          config,
          onEntrypointLoaded: async (initializer) => {
            try {
              options.onEntrypointLoaded?.();
              const runner = await initializer.initializeEngine(config);
              finish(resolve, await runner.runApp());
            } catch (error) { finish(reject, error); }
          },
        })).catch((error) => finish(reject, error));
      });
      return appPromise;
    },
  };
})();
