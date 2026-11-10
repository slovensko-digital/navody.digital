// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const path = require('path')
const { generateWebpackConfig } = require('shakapacker')

const webpackConfig = generateWebpackConfig()

// resolve-url-loader must be used before sass-loader so that relative url()
// references inside imported Sass files keep resolving correctly.
// `root` lets it also resolve root-relative /assets/... URLs emitted by
// navody-digital-frontend (GOV.UK images and fonts) into the npm package,
// so webpack bundles them instead of expecting them at the server root.
const sassRule = webpackConfig.module.rules.find(
  (rule) => rule.test instanceof RegExp && /s[ac]ss/.test(rule.test.source)
)
if (sassRule) {
  const sassLoaderIndex = sassRule.use.findIndex((use) =>
    (typeof use === 'string' ? use : use.loader || '').includes('sass-loader')
  )
  sassRule.use.splice(sassLoaderIndex, 0, {
    loader: 'resolve-url-loader',
    options: {
      root: path.join(__dirname, '../../node_modules/navody-digital-frontend/govuk')
    }
  })
}

module.exports = webpackConfig
