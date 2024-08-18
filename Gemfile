source 'https://rubygems.org'
gem 'awesome_nested_set'
gem 'breadcrumbs_on_rails'
gem 'cancancan'
gem 'classy_enum'
gem 'sidekiq'
gem 'country_select'
gem 'database_cleaner'
gem 'devise'
gem 'devise_invitable'
gem 'devise_zxcvbn'
gem 'draper'
gem 'factory_bot_rails'
gem 'faker'
gem 'has_scope'
gem 'jquery-turbolinks'
gem 'kaminari'
gem 'momentjs-rails' # TODO: change to CDN
gem 'mvi-tempest-builder', git: 'ssh://gerrit.mindvision.com.au/lib/mvi_tempest_builder'
gem 'mvi_validators', git: 'ssh://gerrit.mindvision.com.au/lib/mvi_validators'
gem 'nested_form'
gem 'paranoia'
gem 'phonelib'
gem 'quick_edit', git: 'ssh://gerrit.mindvision.com.au/lib/mvi-admin/quick-edit'
gem 'rails_sortable' # TODO: situational
gem 'rspec-rails'
gem 'simple_form'
gem 'spinjs-rails' # TODO: change to CDN
gem 'userstamper', github: 'mindvision/userstamper'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rails-controller-testing'

  # Help limit n+1 in development and testing
  gem 'bullet' # rails g bullet:install
  # gem 'prosopite'
  # gem 'pg_query'
end

group :development do
  gem 'letter_opener'
  gem 'xray-rails', git: 'https://github.com/brentd/xray-rails.git', branch: 'bugs/ruby-3.0.0'
end

group :production, :preview do
  # gem 'mvi_production', git: 'ssh://gerrit.mindvision.com.au/lib/mvi_production', branch: 'rails-6'
  gem 'gelf' # Graylog for production server logs
  gem 'lograge'
  gem 'rack-mini-profiler', '~> 2.0'
end

gem 'ruby-progressbar'

# Required for boolean label handling
gem 'human_attributes', git: 'https://github.com/mindvision/human_attributes.git', branch: 'master'

# For inline editing
gem 'bootstrap-editable-rails'

# For snippet overriding
gem 'deface'

# For redis related storage
gem 'redis-namespace'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

# Used for accessing private S3 buckets
gem 'aws-sdk-s3'

# Restrict Sprockets version until ready to change over to webpacker for rails 6
gem 'sprockets', '< 4'

# For emails tokens used within the letter templates
gem 'liquid'

# Used for image/file uploading
gem 'carrierwave'

gem 'net-smtp', require: false

# HTML code formatters
gem 'htmlbeautifier'
gem 'rubocop'
gem 'rubocop-rails', require: false

# Needed for seeds
gem 'faraday'
gem 'roo'

# Methods to define a calendar
gem 'simple_calendar'

# Code Editor Syntax Highlighting
gem 'ace-rails-ap'

# For watchdog
gem 'listen'

# To read config/application.yml for environment variables
gem 'client_side_validations'
gem 'figaro', git: 'https://github.com/ffdd/figaro.git', branch: 'main'

ruby '3.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.x'

# The original asset pipeline for Rails
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5', '>= 1.5.4'

# Use the Puma web server
gem 'puma', '>= 5.0'

# Bundle and transpile JavaScript
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator
gem 'turbo-rails'

# Hotwire's modest JavaScript framework
gem 'stimulus-rails'

# Build JSON APIs with ease
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis
gem 'kredis'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Debugging tools
  gem 'debug', platforms: %i[mri windows]
end

group :development do
  # Use console on exceptions pages
  gem 'web-console'

  # Speed up commands on slow machines / big apps
  gem 'spring'
end

group :test do
  # System testing
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
end

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
