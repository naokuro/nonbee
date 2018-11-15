class Front::TopController < Front::ApplicationController
  def index
  end

  def sign_in
    return redirect_to home_url if self.is_login

    email, password = params[:form].values_at(:email, :password)

    pp email
    pp password

    if request.get?
      @t_user = TUser.new
    elsif request.post?
      @t_user = TUser.get_by_email(email)

      pp @t_user

      # 存在しない
      error_email, error_password = ''
      if @t_user.nil?
        @t_user = TUser.new.init({email: email, password: password})
        error_email = 'は登録されていません'
        # パスワード不一致
      elsif @t_user.password != password
        # Set the password for the validation checking.
        @t_user.password = password
        error_password = 'が違います'
      end

      return unless @t_user.valid?(:sign_in)

      pp @t_user.errors
      pp error_email
      pp error_password

      if error_email || error_password
        @t_user.email = email
        @t_user.errors.messages[:email] = error_email if error_email
        @t_user.errors.messages[:password] = error_password if error_password
        return
      end

      set_session(@t_user)

      ret_to = session[:return_to]
      session.delete(:return_to)

      redirect_to ret_to || mypage_url
    end

  end

  def sign_out

  end

  #
  # 会員情報をセッションに格納する
  # @param [Object] t_user 会員情報
  #
  def set_session(t_user)
    session[:login] = { id: t_user.id }
  end

  private :set_session


end
