require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "github_changelog_generator/task"

RSpec::Core::RakeTask.new(:spec)

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = "codeforamerica"
  config.project = "cfa-styleguide-gem"
  config.future_release = "v#{Cfa::Styleguide::VERSION}"
end

namespace :lint do
  task :autocorrect do
    require "rubocop/rake_task"
    RuboCop::RakeTask.new
    Rake::Task["rubocop:auto_correct"].execute
  end
end

task default: %w(lint:autocorrect spec)
