json.articles {
  json.array!(@articles) { | article |
    json.id              article.id
    json.t_user_id       article.t_user_id
    json.article_type    article.article_type
    json.title           article.title
    json.body            article.body
    json.sort            article.sort
    # json.image_file {
    #   json.array!([item.image_file_name_1, item.image_file_name_2, item.image_file_name_3]) { |image_file_name|
    #     json.url image_file_name.url
    #     json.thumb_url image_file_name.thumb.url
    #     json.large_url image_file_name.large.url
    #   }
    # }
  }
}
json.quantity @articles.size
json.res 200