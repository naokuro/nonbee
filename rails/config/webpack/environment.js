const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.config.merge({
    resolve: {
        alias: {
            '@': 'javascripts',
            vue: 'vue/dist/vue.js',
        }
    }
})
module.exports = environment
