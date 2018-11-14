class Front::TopController < Front::ApplicationController
  def index

    pp TUser.get_by_id(1)

  end

  def sign_in


  end

  def sign_out

  end

end
