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
        // Flutter 的回调式加载器不会将入口脚本的网络错误交给 load() Promise。
        const onScriptError = (event) => {
          const script = event.target;
          if (script instanceof HTMLScriptElement && script.src.startsWith(base)) {
            finish(reject, new Error(`Flutter 预览脚本加载失败：${script.src}`));
          }
        };
        const finish = (callback, value) => {
          window.removeEventListener('error', onScriptError, true);
          callback(value);
        };
        window.addEventListener('error', onScriptError, true);
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
