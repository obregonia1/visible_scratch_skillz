Rails.application.routes.draw do
  root to: 'charts#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :charts, except: %i(edit)
  resources :users, only: %i(show)

  namespace "api" do
    resources :charts, only: %i(show)
  end
end
