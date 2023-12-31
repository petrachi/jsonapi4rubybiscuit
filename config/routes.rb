Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :authors, only: %i[index show create update destroy]
      resources :books, only: %i[index show create update destroy]
      resources :publishers, only: %i[index show create update destroy]
    end
  end
end
