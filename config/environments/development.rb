Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = ESSI.config[:rails][:log_level] || :debug

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = ESSI.config.dig(:rails, :mailer, :raise_delivery_errors) || ENV['SMTP_ERRORS']
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => ESSI.config.dig(:rails, :mailer, :address) || ENV['SMTP_ADDRESS'],
    :port => ESSI.config.dig(:rails, :mailer, :port) || ENV['SMTP_PORT'],
    :user_name => ESSI.config.dig(:rails, :mailer, :user_name) || ENV["SMTP_USERNAME"],
    :password => ESSI.config.dig(:rails, :mailer, :password) || ENV["SMTP_PASSWORD"],
    :authentication => ESSI.config.dig(:rails, :mailer, :authentication) || ENV["SMTP_AUTHENTICATION"],
    :enable_starttls_auto => ESSI.config.dig(:rails, :mailer, :enable_starttls_auto) || ENV['SMTP_STARTTLS'],
    :openssl_verify_mode => ESSI.config.dig(:rails, :mailer, :openssl_verify_mode) || ENV["SMTP_SSL_VERIFY"]
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.active_job.queue_adapter = ESSI.config[:rails][:active_job][:queue_adapter].to_sym

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # universal whitelist for docker/virtualbox
  config.web_console.whitelisted_ips = ['172.16.0.0/12', '192.168.0.0/16', '127.0.0.1']

  # Local development should assume to be running secure to match server deployments
  config.force_ssl = true
end
