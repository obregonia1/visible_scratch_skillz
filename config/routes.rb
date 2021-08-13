Rails.application.routes.draw do
  resources :charts, except: %i(edit)

  namespace "api" do
    resources :charts, only: %i(show)
  end
end
