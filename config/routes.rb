Rails.application.routes.draw do
  get 'tweets/index'
  get 'tweets/show'
  get 'tweets/edit'
  devise_for :users
  # root to: "tw#index"
  get "/retrieve_tweets", to: "tweets#retrieve_tweets"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
