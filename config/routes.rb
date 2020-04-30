Rails.application.routes.draw do
  root to: "trending#index"
  resources :visits, only: %i[index show]

  get "summary" => "summary#index", as: :summary
  # get 'phrase/:id', to: "phrase#show", as: :phrase
  resources :phrases do
    member do
      get "usage"
    end
  end

  # get 'phrase/mentions/:id', to: "number_of_mentions#show", as: :mentions
  resources :mentions, only: [:show]

  get "pages/search" => "page_searches#show", as: :page_search
  resources :pages, only: [:show]
  get "surveys/search" => "survey_searches#show", as: :survey_search
  resources :surveys, only: [:show]

  resources :pages_visited, only: [:show]
  # resources :phrase_usage, only: [ :show ]
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
