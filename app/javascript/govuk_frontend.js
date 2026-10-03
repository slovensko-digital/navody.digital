document.addEventListener("turbolinks:before-cache", function () {
  // Components refuse to initialise twice, let them initialise again when the page is restored from cache
  document.querySelectorAll("[data-module]").forEach(($module) => {
    [...$module.attributes]
      .filter(({ name }) => /^data-.+-init$/.test(name))
      .forEach(({ name }) => $module.removeAttribute(name));
  });
});
