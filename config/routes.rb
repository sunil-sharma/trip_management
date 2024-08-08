Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :trips, only: [:create, :index, :show] do
        member do
          patch :check_in
          patch :check_out
          patch :reassign
          get :trip_versions
        end
      end
      post 'login', to: 'sessions#create'
    end
  end
end
