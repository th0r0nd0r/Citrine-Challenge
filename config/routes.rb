Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#root'

  match '/units/si' => 'units#show', :via => :get

  resources :units, only: [:show, :si], defaults: {format: :json}
end
