module.exports = {
  test: /\.scss$(\.erb)?$/,
  exclude: /\.module\.[a-z]+$/,
  use: [
    'vue-style-loader',
    'css-loader',
    {
      loader: 'sass-loader',
      options: {
        data: `
          @import "stylesheets/base/variables.scss";
          @import "stylesheets/base/mixins.scss";
        `
      },
    },
  ]
}