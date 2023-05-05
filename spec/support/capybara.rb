# without lines 1-12, screenshots and html captured from failing specs are blank
# source: https://github.com/mattheworiordan/capybara-screenshot/issues/225
require "action_dispatch/system_testing/test_helpers/setup_and_teardown" 
::ActionDispatch::SystemTesting::TestHelpers::SetupAndTeardown.module_eval do
  def before_setup
    super
  end

  def after_teardown
    super
  end
end

if ENV['IN_DOCKER'].present?
  TEST_HOST='essi.docker'

  args = %w[disable-gpu no-sandbox whitelisted-ips window-size=1400,1400]
  args.push('headless') if ActiveModel::Type::Boolean.new.cast(ENV.fetch('CHROME_HEADLESS_MODE', true))

  options = Selenium::WebDriver::Options.chrome("goog:chromeOptions" => { args: args })

  Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
    driver = Capybara::Selenium::Driver.new(app,
                                            browser: :remote,
                                            capabilities: options,
                                            url: ENV['HUB_URL'])

    # Fix for capybara vs remote files. Selenium handles this for us
    driver.browser.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end

    driver
  end

  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3010
  # renamed container from app to essi  because the app domain is taken by google(gTLD)
  Capybara.app_host = 'http://essi:3010'
else
  TEST_HOST='localhost:3000'
  # @note In January 2018, TravisCI disabled Chrome sandboxing in its Linux
  #       container build environments to mitigate Meltdown/Spectre
  #       vulnerabilities, at which point Hyrax could no longer use the
  #       Capybara-provided :selenium_chrome_headless driver (which does not
  #       include the `--no-sandbox` argument).

  Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
    browser_options = ::Selenium::WebDriver::Chrome::Options.new
    browser_options.args << '--headless'
    browser_options.args << '--disable-gpu'
    browser_options.args << '--no-sandbox'

    http_client = ::Selenium::WebDriver::Remote::Http::Default.new
    http_client.read_timeout = 150

    Capybara::Selenium::Driver.new(app,
                                   browser: :chrome,
                                   options: browser_options,
                                   http_client: http_client)
  end
end

Capybara.default_driver = :rack_test # This is a faster driver
Capybara.javascript_driver = :selenium_chrome_headless_sandboxless # This is slower

Capybara.default_max_wait_time = 10
Capybara.disable_animation = true

Capybara::Screenshot.register_driver(:selenium_chrome_headless_sandboxless) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.autosave_on_failure = false

# Save CircleCI artifacts

def save_timestamped_page_and_screenshot(page, meta)
  filename = File.basename(meta[:file_path])
  line_number = meta[:line_number]

  time_now = Time.now
  timestamp = "#{time_now.strftime('%Y-%m-%d-%H-%M-%S.')}#{'%03d' % (time_now.usec/1000).to_i}"

  screenshot_name = "screenshot-#{filename}-#{line_number}-#{timestamp}.png"
  screenshot_path = "#{Rails.root.join('tmp/capybara')}/#{screenshot_name}"
  page.save_screenshot(screenshot_path)

  page_name = "html-#{filename}-#{line_number}-#{timestamp}.html"
  page_path = "#{Rails.root.join('tmp/capybara')}/#{page_name}"
  page.save_page(page_path)

  puts "\n  Screenshot: tmp/capybara/#{screenshot_name}"
  puts "  HTML: tmp/capybara/#{page_name}"
end
