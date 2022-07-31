const path = require('path');
const glob = require('glob');
const { VueLoaderPlugin } = require('vue-loader');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const baseDir = './app/javascript'

const scripts =
  glob.sync('**/*.js', { cwd: baseDir })
      .reduce((obj, file) => {
        const key = file.replace(/.js$/, '')
        obj[key] = path.resolve(baseDir, key)
        return obj
      }, {})

module.exports = (env, argv) => {
  const isProduction = argv.mode === 'production';
  return {
    mode: isProduction ? 'production' : 'development',
    context: path.resolve(__dirname, baseDir),
    entry: {
      ...scripts
    },
    output: {
      path: path.resolve(__dirname, 'public/packs'),
      filename: isProduction ? '[name].[contenthash].js' : '[name]-[hash].js',
      publicPath: 'packs'
    },
    module: {
      rules: [
        {test: /\.(css|sass)$/, use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']},
        {
          test: /\.(png|jpg|gif)$/,
          use: [
            {
              loader: 'file-loader',
              options: {
                outputPath: 'images/',
                name: '[name]-[hash].[ext]',
              },
            },
          ],
        },
        {
          test: /\.vue$/,
          exclude: /node_modules/,
          loader: 'vue-loader',
          options: {
            extractCSS: true,
          },
        },
      ],
    },
    plugins: [
      new VueLoaderPlugin(),
      new WebpackManifestPlugin({ writeToFileEmit: true, useLegacyEmit: true }),
      new MiniCssExtractPlugin({filename: '[name].[contenthash].css'}),
    ],
    devServer: {
      host: 'localhost',
      port: 3035,
      publicPath: '/packs/',
      contentBase: path.resolve(__dirname, baseDir),
      hot: true,
      disableHostCheck: true,
      historyApiFallback: true
    },
  };
}
