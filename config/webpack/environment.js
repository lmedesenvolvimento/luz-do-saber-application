const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const CircularDependencyPlugin = require('circular-dependency-plugin')
const vue = require('./loaders/vue')
const scss = require('./loaders/scss')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.plugins.prepend('CircularDependencyPlugin', new CircularDependencyPlugin({
  // exclude detection of files based on a RegExp
  exclude: /a\.js|node_modules/,
  // include specific files based on a RegExp
  include: /dir/,
  // add errors to webpack instead of warnings
  failOnError: true,
  // allow import cycles that include an asyncronous import,
  // e.g. via import(/* webpackMode: "weak" */ './file.js')
  allowAsyncCycles: false,
  // set the current working directory for displaying module paths
  cwd: process.cwd(),
}))

environment.loaders.prepend('vue', vue)
environment.loaders.prepend('sass', scss)
module.exports = environment
