module.exports = {
  content: [
    "./js/**/*.js",
    "./css/**/*.css",
    "../lib/**/*.*ex",
    "../**/*.*exs",
    "../../../config/*.*exs",

    // We need to include the Palette dependency so the classes get picked up by JIT.
    "../deps/palette/**/*.*ex",
  ],
};
