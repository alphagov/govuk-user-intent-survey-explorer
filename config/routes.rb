Rails.application.routes.draw do
  root to: "home#index"
  resources :visits, only: [:index, :show]

  get "/search" => "search#show", as: :search
  resources :pages, only: [:show]
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
