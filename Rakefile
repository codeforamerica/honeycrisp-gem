require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "github_changelog_generator/task"

RSpec::Core::RakeTask.new(:spec)

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = "codeforamerica"
  config.project = "honeycrisp-gem"
  config.future_release = "v#{Cfa::Styleguide::VERSION}"
  config.exclude_labels = ["discussion", "wontfix"]
end

namespace :lint do
  task :autocorrect do
    require "rubocop/rake_task"
    RuboCop::RakeTask.new
    Rake::Task["rubocop:auto_correct"].execute
  end
end

namespace :assets do
  desc "Package JS and CSS assets to /dist for use externally."
  task :package do
    require "tasks/distribution"
    require "sprockets"
    add_jquery_to_path
    Distribution.new
  end
end

def add_jquery_to_path
  jquery_path = Dir.entries("#{Gem.paths.home}/gems/").detect do |dir|
    dir.match(/jquery-rails(.*)/)
  end
  $LOAD_PATH.unshift("#{Gem.paths.home}/gems/#{jquery_path}/vendor/")
end

task default: %w(lint:autocorrect spec)
