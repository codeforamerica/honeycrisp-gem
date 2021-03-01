ENV["RAILS_ENV"] ||= "test"

require File.expand_path("test_app/config/environment.rb", __dir__)
require "rspec/rails"
require "axe/rspec"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  unless ENV["CI"]
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
  end

  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.order = "random"
end
