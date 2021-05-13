Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	namespace :api do
		namespace :v1 do
			resources :users
			get '/users', to: '/api/v1/users#index'
			post '/users', to: '/api/v1/users#create'
			delete '/users/:id', to: '/api/v1/users#destroy'
			get '/users_hierarchy/:hierarchy_point', to: '/api/v1/users#hierarchy'
		end
	end
end
