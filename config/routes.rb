Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#root'

  match '/units/si' => 'units#si', :via => :get

  resources :units, only: [:si], defaults: {format: :json}
end
