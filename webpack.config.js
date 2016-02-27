var webpackTargetElectronRenderer = require('webpack-target-electron-renderer');

var options = {
  entry: './src/index.js',

  output: {
    path: './',
    filename: 'bundle.js',
  },

  resolve: {
    extensions: ['', '.js', '.elm'],
    alias: {
      'Api': __dirname + '/src/Api'
    },
    packageMains: ['webpack', 'browser', 'web', 'browserify', ['jam', 'main'], 'main']
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015']
        }
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      {
        test: /\.scss$/,
        loaders: ['style', 'css', 'sass']
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader'
      }
    ],

    noParse: /\.elm$/
  },

  externals: [
    // put your node 3rd party libraries which can't be built with webpack here (mysql, mongodb, and so on..)
    'ed25519-supercop'
  ],

  devServer: {
    inline: true,
    stats: 'errors-only'
  }
};

options.target = webpackTargetElectronRenderer(options)

module.exports = options;
