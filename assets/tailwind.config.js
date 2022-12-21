module.exports = {
  content: [
    "./js/**/*.js",
    "./css/**/*.css",
    "../lib/**/*.*ex",
    "../**/*.*exs",
    "../../../config/*.*exs",

    // We need to include the Palette dependency so the classes get picked up by JIT.
    "../deps/palette/**/*.*ex",

    // TODO: This is for development only... we need to find a way to remove this line.
    "../../palette/**/*.*ex"
  ]
};
