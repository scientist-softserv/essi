# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'webmock/rspec'
require 'vcr'
require 'capybara/rails'
require 'capybara-screenshot/rspec'
require 'database_cleaner'
require 'active_fedora/cleaner'
require 'selenium-webdriver'
require 'webdrivers'
require 'i18n/debug' if ENV['I18N_DEBUG']
require 'byebug' unless ENV['CI']
require 'noid/rails/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
ActiveJob::Base.queue_adapter = :test

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless_sandboxless #
  end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include Warden::Test::Helpers, type: :feature
  config.include(ControllerLevelHelpers, type: :view)
  config.include CapybaraWatcher, type: :feature
  config.before(:each, type: :view) { initialize_controller_helpers(view) }

  # The following methods ensure proper handling of minted IDs via Noid to eliminate LDP conflict errors
  include Noid::Rails::RSpec
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    disable_production_minter!
    AdminSet.find_or_create_default_admin_set_id
    profile_path = Rails.root.join('config', 'metadata_profile', 'essi_short.yaml')
    @allinson_flex_profile = AllinsonFlex::Importer.load_profile_from_path(path: profile_path.to_s)
    @allinson_flex_profile.save
  end

  config.after(:suite)  { enable_production_minter! }

  config.around do |example|
    #  Sometimes tests need a clean Fedora and Solr environment to work properly. To invoke the ActiveFedora
    #  cleaner use the :clean metadata directive like:
    #   describe "#structure", :clean do
    #      some example
    #    end
    if example.metadata[:clean]
      ActiveFedora::Cleaner.clean!
      ActiveFedora.fedora.connection.send(:init_base_path) if example.metadata[:js]

      # Recreate only the AdminSet, not the associated permission template that is still in the database.
      # (Instead of AdminSet.find_or_create_default_admin_set_id)
      AdminSet.create id: AdminSet::DEFAULT_ID, title: Array.wrap(AdminSet::DEFAULT_TITLE)

      # Let the DatabaseCleaner take care of database rows written in an example
      if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
        DatabaseCleaner.strategy = :truncation
      else
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.start
      end

      DatabaseCleaner.cleaning do
        example.run
      end
    else
      example.run
    end
  end

  config.after(:each) do |example|
    if example.metadata[:js]
      save_timestamped_page_and_screenshot(Capybara.page, example.metadata) if example.exception
    end
  end

  config.after(:each, type: :feature) do
    Warden.test_reset!
    Capybara.reset_sessions!
    page.driver.reset!
    # Keep up to the number of screenshots specified in the hash
    Capybara::Screenshot.prune_strategy = { keep: 10 }
  end

  config.after(:suite) do
    # Clean everything
    DatabaseCleaner.clean
    ActiveFedora::Cleaner.clean!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true

  # Ignore webdriver updates
  driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  config.ignore_hosts(*driver_hosts)
end

CapybaraWatcher.configure do |options|
  options[:timeout] = 5 # Time in seconds
end
