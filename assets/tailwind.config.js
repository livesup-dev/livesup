let plugin = require("tailwindcss/plugin");
module.exports = {
  content: [
    "../**/*.*exs",
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
  ],
  darkMode: "class",
  plugins: [
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        "&.phx-click-loading",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        "&.phx-submit-loading",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        "&.phx-change-loading",
        ".phx-change-loading &",
      ])
    ),
    require("@tailwindcss/line-clamp"),
    function ({ addVariant }) {
      addVariant(
        "supports-backdrop",
        "@supports ((-webkit-backdrop-filter: initial) or (backdrop-filter: initial))"
      );
    },
  ],
};
