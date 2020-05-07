source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.0.2", ">= 6.0.2.1"
# Use Puma as the app server
gem "puma", "~> 4.3"
# Use SCSS for stylesheets
gem "sass-rails", "< 6"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "govuk_publishing_components", "~> 21.21"

gem "pg", "~> 1"
gem 'elasticsearch-rails', '~> 6.1.0'
gem 'elasticsearch-model', '~> 6.1.0'
gem 'elasticsearch-persistence', '~> 6.1.0'
gem 'gds-api-adapters', '~> 63.6'
gem 'kaminari'

gem "chartkick", "~> 3.3.1"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i(mri mingw x64_mingw)
  gem "rspec-rails", "~> 3"
  gem "rubocop-govuk", "~> 3"
  gem "factory_bot_rails"
  gem "guard-rspec"
  gem 'pry', '~> 0.12.2'
end

group :test do
  gem "simplecov", "~>0.18"
  gem "webmock", "~> 3"
  gem "capybara"
  gem "elasticsearch-extensions"
  gem "mocha"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  gem "rails-erd", "~> 1.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
