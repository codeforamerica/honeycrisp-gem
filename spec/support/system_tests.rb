require "selenium-webdriver"

Capybara.server = :webrick

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if ENV["SHOW_BROWSER"]
      example.metadata[:js] = true
      driven_by :selenium, using: :chrome
    elsif example.metadata[:js]
      driven_by :selenium, using: :headless_chrome
    else
      driven_by :rack_test
    end
  end
end
