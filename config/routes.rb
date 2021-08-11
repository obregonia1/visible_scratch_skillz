Rails.application.routes.draw do
  resources :charts

  namespace "api" do
    resources :charts, only: %i(show)
  end
end
