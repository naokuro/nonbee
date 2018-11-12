Rails.application.routes.draw do
  get 'top/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # api
  namespace :api, { format: 'json' } do
    namespace :v1 do

    end
  end

end
