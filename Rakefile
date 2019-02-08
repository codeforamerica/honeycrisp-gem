require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "github_changelog_generator/task"

RSpec::Core::RakeTask.new(:spec)

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'codeforamerica'
  config.project = 'cfa-styleguide-gem'
  config.future_release = "v#{Cfa::Styleguide::VERSION}"
end

task :default => [:spec]
