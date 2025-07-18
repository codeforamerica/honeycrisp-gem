require_relative "boot"

require "logger"
require "sprockets/railtie"
require "action_controller/railtie"
require "action_view/railtie"

require "cfa/styleguide"

module TestApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.to_prepare do
      warn "Loaded Rails #{Rails::VERSION::STRING}, Sprockets #{Sprockets::VERSION}",
        "Asset paths: #{Rails.application.config.assets.paths}"
    end
  end
end
