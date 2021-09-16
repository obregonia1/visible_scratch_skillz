Rails.application.routes.draw do
  root to: 'home#index'
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'tos', to: 'home#tos'
  get 'welcome', to: 'welcome#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :charts, except: %i(edit)
  resources :users, only: %i(show)

  namespace "api" do
    resources :charts, only: %i(show)
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
