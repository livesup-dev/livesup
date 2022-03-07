const path = require('path');
const glob = require('glob');
const HardSourceWebpackPlugin = require('hard-source-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    mode: options.mode || "production",
    optimization: {
      minimizer: [
        new TerserPlugin({parallel: true, terserOptions: {sourceMap: devMode }}),
        new CssMinimizerPlugin()
      ]
    },
    entry: {
      'app': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: [
                ['@babel/preset-env', { targets: "defaults" }]
              ]
            }
          }
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'sass-loader',
            'postcss-loader',
          ],
        },
        {
          test: /\.(ttf|woff|woff2|eot|svg)$/,
          use: ["file-loader"],
        },
        {
          test: /\.(png|jpg|gif|svg)$/,
          exclude: /fonts/,
          loader: "file-loader",
          options: {
            name: "/images/[name].[ext]"
        }
        },
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({
        patterns: [
          { from: 'static/', to: '../' }
        ]
      })
    ]
      .concat()
    // .concat(devMode ? [new HardSourceWebpackPlugin()] : [])
  }
};
