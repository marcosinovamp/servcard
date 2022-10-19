Rails.application.routes.draw do
  get 'jogos/card'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'jogos#home'
  get 'card/:id', to: 'jogos#card'

end
