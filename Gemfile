source 'https://rubygems.org'
ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use 12 factor for easy deploy w/ Heroku
gem 'rails_12factor', '~> 0.0.3', group: :production
# Use slim for views
gem 'slim', '~> 3.0.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# JS-Routes makes route helpers accessible from javascript
gem 'js-routes', '~> 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Code Highlight
gem 'coderay'
# Matrix was removes from ruby defaults in 3.1
gem 'matrix', '~> 0.4.2'




group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'

  # gem "better_errors"
  gem "binding_of_caller"

  # Create PNG files
  gem 'chunky_png', '~> 1.3', '>= 1.3.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]









gem "jsonapi.rb", "~> 1.6"
gem "ransack", "~> 2.5.0"
gem "pundit", "~> 2.1"
gem "rectify", "~> 0.13.0"

group :test do
  gem "database_cleaner", "~> 1.7.0"
  gem "rspec", "~> 3.7"
  gem "rspec-collection_matchers", "~> 1.1"
  # gem "rspec-its", "~> 1.3"
  gem "rspec-rails"
  # gem "shoulda-matchers", "~> 4.0"
  gem "factory_bot_rails", "~> 4.10"
  gem "faker", "~> 1.6", ">= 1.6.6"
  gem "super_diff"
end
