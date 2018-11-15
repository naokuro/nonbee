class Front::ApplicationController < ActionController::Base
  layout 'front/layout'

  before_action :before_common

  # アクセサ
  attr_accessor :is_login
  attr_accessor :t_user_id
  attr_accessor :t_user

  #
  # 共通事前処理アクション
  #
  def before_common

    # セッションログイン処理
    login

  end

  protected

  #
  # ログイン処理アクション
  #
  def login

    store_location

    self.is_login   = false
    self.is_login = session[:login] != nil && session[:login][:id] != nil
    if self.is_login
      self.t_user_id = session[:login][:id]
      self.t_user = TUser.get_by_id(self.t_user_id)
      if self.t_user.blank?
        session.delete(:login)
        session.delete(:return_to)
        self.is_login = false
      end
    end
  end

  private

  #
  # URLを記録
  #
  def store_location
    redirect = false
    return unless redirect
    unless session[:login].present?
      session[:return_to] = request.fullpath
    end
  end

end
