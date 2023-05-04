Rails.application.routes.draw do
  get '/health', to: 'health#show' # used for liveness probe
  get '/readiness', to: 'health#readiness'

  resources :services, only: [:index, :create, :destroy] do
    get '/users/:user_id', to: 'services#services_for_user', on: :collection
    resources :versions, only: [:index, :create, :show] do
      get :latest, on: :collection
      get :previous, on: :collection
    end

    get '/items/all', as: :items, to: 'component_items#index'
    get '/components/:component_id/items', to: 'component_items#show'
    post '/components/:component_id/items/all', to: 'component_items#create'
  end

  match '*unmatched', to: 'application#not_found', via: :all
end
