{{flutter_js}}
{{flutter_build_config}}

let hyUiAppPromise;

/** Starts one Flutter engine that can render into multiple host DOM elements. */
window.loadHyUiPreview = function loadHyUiPreview(assetBase) {
  if (hyUiAppPromise) return hyUiAppPromise;

  const normalizedBase = assetBase.endsWith('/') ? assetBase : `${assetBase}/`;
  hyUiAppPromise = new Promise((resolve, reject) => {
    _flutter.loader.load({
      config: {
        entrypointBaseUrl: normalizedBase,
      },
      onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
        try {
          const engine = await engineInitializer.initializeEngine({
            assetBase: normalizedBase,
            entrypointBaseUrl: normalizedBase,
            multiViewEnabled: true,
          });
          const app = await engine.runApp();
          resolve(app);
        } catch (error) {
          reject(error);
        }
      },
    });
  });

  return hyUiAppPromise;
};
