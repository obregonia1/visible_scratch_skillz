Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :charts, except: %i(edit)

  namespace "api" do
    resources :charts, only: %i(show)
  end
end
