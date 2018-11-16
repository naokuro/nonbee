import Vue from 'vue'
import Header from './components/header'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        el: '#app',
        components: {
            'navbar': Header,
        }
    });
});