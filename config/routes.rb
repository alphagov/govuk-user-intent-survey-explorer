Rails.application.routes.draw do
  root to: "home#index"
  resources :visits, only: [:index, :show]

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
