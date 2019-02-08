#
# Class Api::V1::ArticleController provides
#
# @author onishi
#
class Api::V1::ArticleController < Api::V1::ApplicationController

  def list
    pp 'てすとん'
    @articles = TArticle.all
  end

  def add
    pp 'こんちわー！'
    pp params

    params[:article] ||= {}
    params[:article][:t_user_id] = 1
    params[:article][:article_type] = 1
    params[:article][:title] = 'てすとん'
    params[:article][:sort] = 1
    @article = TArticle.add(params[:article])

  end

  def done

  end

end
