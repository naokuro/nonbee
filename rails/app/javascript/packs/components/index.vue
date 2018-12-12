<template>
    <div>
        <!-- 新規作成部分 -->
        <div class="row">
            <div class="col s10 m11">
            </div>
            <div class="col s2 m1">
                <div class="btn-floating waves-effect waves-light red" @click="openModal">
                    <i class="material-icons">add</i>
                </div>
            </div>
        </div>
        <!-- リスト表示部分 -->
        <div>
            <ul class="collection">
                <li v-for="article in articles" v-if="!article.is_done" v-bind:id="'row_article_' + article.id"
                    class="collection-item">
                    <input type="checkbox" v-on:change="doneTask(article.id)" v-bind:id="'article_' + article.id"/>
                    <label v-bind:for="'article_' + article.id">{{ article.name }}</label>
                </li>
            </ul>
        </div>

        <!-- コンポーネント MyModal -->
        <RegistModal @close="closeModal" v-if="this.modal">
            <!-- default スロットコンテンツ -->
            <p>Vue.js Modal Window!</p>
            <div><input v-model="newArticle"></div>
            <!-- /default -->
            <!-- footer スロットコンテンツ -->
            <template slot="footer">
                <button @click="createArticle">送信</button>
            </template>
            <!-- /footer -->
        </RegistModal>

    </div>

</template>

<script>
    import axios from 'axios';
    import RegistModal from './article/regist_modal';

    export default {
        components: {
            RegistModal
        },
        data: function () {
            return {
                modal: false,
                articles: [],
                newArticle: ''
            }
        },
        mounted: function () {
            this.fetchArticles();
        },
        methods: {
            openModal: function() {
                this.modal = true
            },
            closeModal: function() {
                this.modal = false
            },
            fetchArticles: function () {
                axios.get('/api/v1/articles').then((response) => {
                    console.log(response.data);
                    if (response.data == null) return;
                    for (let i = 0; i < response.data.articles.length; i++) {
                        this.articles.push(response.data.articles[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
            },
            createArticle: function () {
                if (!this.newArticle) return;
                axios.post('/api/v1/articles', {article: {name: this.newArticle}}).then((response) => {
                    this.articles.unshift(response.data.article);
                    this.newArticle = '';
                }, (error) => {
                    console.log(error);
                });
            },
        }
    }
</script>

<style scoped>
    [v-cloak] {
        display: none;
    }

    /*.display_none {*/
        /*display: none;*/
    /*}*/

    /* 打ち消し線を引く */
    .line-through {
        text-decoration: line-through;
    }
</style>