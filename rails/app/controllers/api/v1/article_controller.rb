#
# Class Api::V1::ArticleController provides
#
# @author onishi
#
class Api::V1::ArticleController < Api::V1::ApplicationController

  def list
    pp 'てすとん'
    @articles = []
  end

  def add

    pp params

  end

  def done

  end

end
