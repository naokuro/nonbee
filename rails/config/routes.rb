Rails.application.routes.draw do

  # front
  scope module: :front do
    # top
    get 'top/index'
    post 'top/sign_in',  to: 'top#sign_in', as: 'sign_in'
    get  'top/sign_out', to: 'top#sign_out', as: 'sign_out'

    # home
    root to: 'home#index'
    get '/home', to: 'home#index', as: 'home'
    get '/about',   to: 'home#index'
    get '/contact', to: 'home#index'
  end

  # api
  namespace :api, { format: 'json' } do
    namespace :v1 do

      get 'articles', to: 'article#list'


    end
  end

end
