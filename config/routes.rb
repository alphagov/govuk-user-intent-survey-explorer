Rails.application.routes.draw do
  root to: "home#index"

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
