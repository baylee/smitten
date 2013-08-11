FinalProject::Application.routes.draw do
  get 'profile' => 'users#show', as: 'profile'

  get "messages/:partner_id" => 'messages#show', as: :message

  post "messages/:partner_id" => 'messages#create', as: :messages

  match 'users/auth/:service/callback' => 'services#create'
  resources :services, :only => [:index, :create, :destroy]
  resources :sparks, :only => [:show, :new, :create, :edit, :update, :destroy]
  get 'places' => 'sparks#places', as: 'places'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}


  root :to => 'home#index'

end

