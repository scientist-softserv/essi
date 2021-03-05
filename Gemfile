source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
end
gem 'mysql2'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'bixby'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'solr_wrapper', '>= 0.3'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'rails-controller-testing'
  gem 'vcr'
  gem 'webmock'
  gem 'jasmine-jquery-rails'
  gem 'jasmine-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'debase'
  gem 'ruby-debug-ide'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'hyrax', '~> 2.6.0'
gem 'browse-everything', '~> 1.0.2' 
gem 'rsolr'
gem 'jquery-rails'
gem 'devise'
gem 'devise-i18n'
gem 'devise-guests', '~> 0.6'
gem 'omniauth'
gem 'omniauth-iu-cas'
gem 'ldap_groups_lookup', '~> 0.6.0'
gem 'hydra-role-management'
gem 'riiif', '~> 2.0'
gem 'marc', '~> 1.0.0'
gem 'sidekiq'
gem 'switch_user'
gem 'iso-639'
gem 'blacklight_iiif_search'
gem 'iiif_manifest'
gem 'i18n-js'
gem 'bagit'
gem 'validatable'
gem 'country_select', '~> 4.0', require: 'country_select_without_sort_alphabetical'
gem 'prawn'
gem 'airbrake'
gem 'allinson_flex', github: 'samvera-labs/allinson_flex'
# gem 'allinson_flex', path: 'vendor/engines/allinson_flex'

# Bulk Import / Export
#TODO: N8 specific - use local for dev; use github for test/staging
gem 'bulkrax', git: 'https://github.com/samvera-labs/bulkrax.git'
#gem 'bulkrax', path: 'vendor/engines/bulkrax'
gem 'willow_sword', github: 'notch8/willow_sword'
gem 'webpacker'
gem 'react-rails'
