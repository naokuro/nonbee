Rails.application.routes.draw do

  # front
  scope module: :front do
    # top
    get 'top/index'
    post 'top/sign_in',  to: 'top#sign_in', as: 'sign_in'
    get  'top/sign_out', to: 'top#sign_out', as: 'sign_out'

    # home
    get 'home/index', to: 'home#index', as: 'home'
  end

  # api
  namespace :api, { format: 'json' } do
    namespace :v1 do

    end
  end

end
