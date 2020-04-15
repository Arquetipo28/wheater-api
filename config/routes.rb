Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    get 'wheater/min', to: 'wheater#show_min'
    get 'wheater', to: 'wheater#show'
  end
end
