source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'pg'
gem 'will_paginate', '~> 3.1.0'
gem 'jquery-rails'
gem "rack", ">= 2.2.3"
gem "websocket-extensions", ">= 0.1.5"

# Action
gem "actionview", ">= 6.0.3.1"
gem "actionpack", ">= 6.0.3.2"
gem "activestorage", ">= 6.0.3.1"
gem "activesupport", ">= 6.0.3.1"

# Puma
gem "puma", ">= 4.3.5"

# Devise
gem 'devise'

# Json Web Token
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'rails-controller-testing'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :test do
  gem 'database_cleaner-active_record'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.0'
  
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end


group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
