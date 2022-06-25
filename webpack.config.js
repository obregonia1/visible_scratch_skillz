const path = require('path');
const glob = require('glob');
const { VueLoaderPlugin } = require('vue-loader');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const scripts =
  glob.sync('**/*.js', { cwd: './app/javascript' })
      .reduce((obj, file) => {
        const key = file.replace(/.js$/, '')
        obj[key] = path.resolve('app/javascript', key)
        return obj
      }, {})

module.exports = (env, argv) => {
  const isProduction = argv.mode === 'production';
  return {
    context: path.resolve(__dirname, 'app/javascript'),
    entry: {
      ...scripts
    },
    output: {
      path: path.resolve(__dirname, 'public/packs'),
      filename: isProduction ? '[name]-[contentHash].js' : '[name]-[hash].js',
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
      new MiniCssExtractPlugin({filename: '[name]-[contentHash].css'}),
    ],
    devServer: {
      host: 'localhost',
      port: 3035,
      publicPath: '/packs/',
      contentBase: path.resolve(__dirname, 'app/javascript'),
      hot: true,
      disableHostCheck: true,
      historyApiFallback: true
    },
  };
}
