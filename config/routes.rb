Rails.application.routes.draw do
  resources :readings
  resources :thermostats, path: :stats  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
