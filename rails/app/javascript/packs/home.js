import Vue from 'vue'
import Index from './components/index'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        el: '#app',
        data: {
            hoge: 'あいうえお'
        },
        components: {
            'index': Index
        }
    });
});