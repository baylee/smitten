FinalProject::Application.routes.draw do
  get "messages/:partner_id" => 'messages#show', as: :conversation

  get "messages/:partner_id/new" => 'messages#new'

  post "messages/:partner_id" => 'messages#create'

  match 'users/auth/:service/callback' => 'services#create'
  resources :services, :only => [:index, :create, :destroy]

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}


  root :to => 'home#index'

end

