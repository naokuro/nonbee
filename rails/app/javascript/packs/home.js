import Vue from 'vue'
import Router from './router/router'
import Header from './components/header'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        router: Router,
        el: '#app',
        components: {
            'navbar': Header,
        }
    });
});