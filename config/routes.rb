Rails.application.routes.draw do
  root to: 'charts#index'
  get 'users/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :charts, except: %i(edit)

  namespace "api" do
    resources :charts, only: %i(show)
  end
end
