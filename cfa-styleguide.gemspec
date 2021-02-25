lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cfa/styleguide/version"

Gem::Specification.new do |spec|
  spec.name          = "cfa-styleguide"
  spec.version       = Cfa::Styleguide::VERSION
  spec.authors       = ["https://github.com/codeforamerica/honeycrisp-gem/graphs/contributors"]
  spec.email         = ["christa@codeforamerica.org"]

  spec.summary       = "A design system created for Code for America services."
  spec.description   = "Honeycrisp Design System"
  spec.homepage      = "https://github.com/codeforamerica/honeycrisp-gem"
  spec.metadata      = { "documentation_uri" => "https://honeycrisp.herokuapp.com" }
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
  spec.add_runtime_dependency "sass"
  spec.add_development_dependency "axe-matchers", "~> 2.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "capybara-selenium"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "github_changelog_generator"
  spec.add_development_dependency "percy-capybara", "~> 4.0.0.pre.beta2"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rails", "~> 5.2.4.4"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop", "~> 0.64.0"
  spec.add_development_dependency "sassc-rails"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "uglifier"
end
