lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cfa/styleguide/version"

Gem::Specification.new do |spec|
  spec.name          = "cfa-styleguide"
  spec.version       = Cfa::Styleguide::VERSION
  spec.authors       = ["https://github.com/codeforamerica/cfa-styleguide-gem/graphs/contributors"]
  spec.email         = ["christa@codeforamerica.org"]

  spec.summary       = "A pattern library for CfA products, based on the GetCalFresh styleguide"
  spec.description   = "Code for America Styleguide"
  spec.homepage      = "https://github.com/codeforamerica/cfa-styleguide-gem"
  spec.metadata      = { "documentation_uri" => "https://cfa-styleguide.herokuapp.com" }
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "autoprefixer-rails"
  spec.add_runtime_dependency "bourbon"
  spec.add_runtime_dependency "jquery-rails"
  spec.add_runtime_dependency "neat", "~> 1.8.0"
  spec.add_runtime_dependency "prism-rails"
  spec.add_development_dependency "axe-matchers", "~> 2.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "capybara-selenium"
  spec.add_development_dependency "github_changelog_generator"
  spec.add_development_dependency "percy-capybara", "~> 4.0.0.pre.beta2"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rails", ">= 3.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop", "~> 0.64.0"
  spec.add_development_dependency "selenium-webdriver"
end
