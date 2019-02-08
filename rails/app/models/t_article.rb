#
# Class TArticle provides 記事モデル
#
# @author onishi
#
class TArticle < ApplicationRecord
  extend ApplicationRecord::TModule

  def self.add(params)
    self.create!({t_user_id: params[:t_user_id],
                  article_type: params[:article_type],
                  title: params[:title],
                  body: params[:body],
                  sort: params[:sort],
                  del_flg: 0
                 })
  end

end
