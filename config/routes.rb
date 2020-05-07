Rails.application.routes.draw do
  root to: "trending#index"
  resources :visits, only: %i[index show]

  get "summary" => "summary#index", as: :summary
  resources :phrases do
    member do
      get "usage"
    end
  end

  resources :mentions, only: [:show]

  get "pages/search" => "page_searches#show", as: :page_search
  resources :pages, only: %i[show index]
  get "surveys/search" => "survey_searches#show", as: :survey_search
  resources :surveys, only: [:show]

  resources :pages_visited, only: [:show]
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
