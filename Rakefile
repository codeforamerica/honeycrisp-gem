require "dotenv/load"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

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
    puts "Assets generated to /dist"
  end
end

desc "Commit version and changelog"
task :release, [:version_bump] do |_t, args|
  version_bump = args[:version_bump]
  if version_bump.nil?
    puts "Pass a version [major|minor|patch|pre|release] or a given version number [x.x.x]:"
    puts "$ bundle exec rake release[VERSION_BUMP]"
    exit(1)
  end

  if ["major", "minor"].include? version_bump
    puts "\n== Reviewing documentation =="
    puts "This is a #{version_bump} release. Have you updated MIGRATING.md? (y/n)"

    input = $stdin.gets.strip
    unless input == "y"
      puts "Please update MIGRATING.md, commit the changes, then re-run the release command."
      exit(1)
    end
  end

  puts "\n== Bumping version number =="
  system! "gem bump --no-commit --version #{version_bump}"

  puts "\n== Reloading Cfa::Styleguide::VERSION"
  load File.expand_path("lib/cfa/styleguide/version.rb", __dir__)
  new_version = Cfa::Styleguide::VERSION

  puts "\n== Updating Changelog =="
  system! ENV, "bundle exec github_changelog_generator --user codeforamerica --project honeycrisp-gem --future-release v#{new_version} --exclude-labels discussion,wontfix"

  puts "\n== Updating Gemfile.lock version =="
  system! "bundle install"

  puts "\n== Creating git commit  =="
  system! "git add lib/cfa/styleguide/version.rb CHANGELOG.md Gemfile.lock"
  system! "git commit -m \"Release honeycrisp-gem v#{Cfa::Styleguide::VERSION}\""
  system! "git tag v#{Cfa::Styleguide::VERSION}"

  puts "\n== Next steps =="
  puts " Push commit and tag to Github:"
  puts "   $ git push origin && git push origin --tags"
end

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

def add_jquery_to_path
  jquery_path = Dir.entries("#{Gem.paths.home}/gems/").detect do |dir|
    dir.match(/jquery-rails(.*)/)
  end
  $LOAD_PATH.unshift("#{Gem.paths.home}/gems/#{jquery_path}/vendor/")
end

task default: %w(lint:autocorrect spec)
