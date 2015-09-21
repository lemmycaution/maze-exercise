Rails.application.routes.draw do
  resources :mazes, except: [:edit, :update]
  root to: 'mazes#index'
end
