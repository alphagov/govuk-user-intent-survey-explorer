class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV["GOVUK_USERNAME"], password: ENV["GOVUK_PASSWORD"], if: -> { Rails.env.production? }
end
