Rails.application.routes.draw do
  root to: "trending#index"
  resources :visits, only: %i[index show]

  get "summary" => "summary#index", as: :summary
  resources :phrases do
    member do
      get "usage"
    end
  end

  resources :generic_phrases, only: %i[index show]

  resources :mentions, only: [:show]

  get "pages/search" => "page_searches#show", as: :page_search
  resources :pages, only: %i[index]
  get "page/*base_path", to: "pages#show", param: :base_path, as: :page
  get "surveys/search" => "survey_searches#show", as: :survey_search

  resources :pages_visited, only: [:show]
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
