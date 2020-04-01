Rails.application.routes.draw do
  root to: "home#index"
  resources :visits, only: [:index, :show]

  get "pages/search" => "page_searches#show", as: :page_search
  resources :pages, only: [:show]
  get "surveys/search" => "survey_searches#show", as: :survey_search
  resources :surveys, only: [:show]
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
