FinalProject::Application.routes.draw do
  get "messages/:partner_id" => 'messages#show', as: :message

  post "messages/:partner_id" => 'messages#create', as: :messages

  match 'users/auth/:service/callback' => 'services#create'
  resources :services, :only => [:index, :create, :destroy]

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}


  root :to => 'home#index'

end

