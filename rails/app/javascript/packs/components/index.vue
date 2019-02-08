<template>
    <div>
        <!-- 新規作成部分 -->
        <div class="row">
            <input type="text" v-model="newArticle" v-on:keydown.enter="createArticle">
        </div>
        <!-- リスト表示部分 -->
        <div>
            <ul class="collection">
                <li v-for="article in articles" v-bind:id="'row_article_' + article.id" class="collection-item">
                    <input type="checkbox" v-on:change="doneTask(article.id)" v-bind:id="'article_' + article.id"/>
                    <label v-bind:for="'article_' + article.id">タイトル：{{ article.title }}</label>
                    <label v-bind:for="'article_' + article.id">本文：{{ article.body }}</label>
                </li>
            </ul>
        </div>
    </div>

</template>

<script>
    import axios from 'axios';

    export default {
        components: {
        },
        data: function () {
            return {
                articles: [],
                newArticle: ''
            }
        },
        mounted: function () {
            this.fetchArticles();
        },
        methods: {
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

                console.log(this.newArticle);

                if (!this.newArticle) return;
                axios.post('/api/v1/articles', {article: {body: this.newArticle}}).then((response) => {
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