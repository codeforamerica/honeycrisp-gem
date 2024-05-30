require "dotenv/load"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "tasks/distribution"
require "sprockets"

RSpec::Core::RakeTask.new(:spec)

namespace :lint do
  desc "Run RuboCop autocorrect"
  task :autocorrect do
    RuboCop::RakeTask.new(:rubocop)
    Rake::Task["rubocop:auto_correct"].invoke
  end
end

namespace :assets do
  desc "Package JS and CSS assets to /dist for external use."
  task :package do
    add_jquery_to_path
    Distribution.new
    puts "Assets generated to /dist"
  end
end

desc "Commit version and changelog"
task :release, [:version_bump] do |_t, args|
  version_bump = args[:version_bump]

  unless version_bump
    puts "Pass a version [major|minor|patch|pre|release] or a given version number [x.x.x]:"
    puts "$ bundle exec rake release[VERSION_BUMP]"
    exit(1)
  end

  if %w[major minor].include?(version_bump)
    puts "\n== Reviewing documentation =="
    puts "This is a #{version_bump} release. Have you updated MIGRATING.md? (y/n)"

    input = $stdin.gets.strip.downcase
    unless input == "y"
      puts "Please update MIGRATING.md, commit the changes, then re-run the release command."
      exit(1)
    end
  end

  execute_release_steps(version_bump)
end

def execute_release_steps(version_bump)
  puts "\n== Bumping version number =="
  system!("gem bump --no-commit --version #{version_bump}")

  puts "\n== Reloading Cfa::Styleguide::VERSION"
  load File.expand_path("lib/cfa/styleguide/version.rb", __dir__)
  new_version = Cfa::Styleguide::VERSION

  puts "\n== Updating Changelog =="
  system!(ENV, "bundle exec github_changelog_generator --user codeforamerica --project honeycrisp-gem --future-release v#{new_version} --exclude-labels discussion,wontfix")

  puts "\n== Updating Gemfile.lock version =="
  system!("bundle install")

  puts "\n== Creating git commit  =="
  system!("git add lib/cfa/styleguide/version.rb CHANGELOG.md Gemfile.lock")
  system!("git commit -m \"Release honeycrisp-gem v#{new_version}\"")
  system!("git tag v#{new_version}")

  puts "\n== Next steps =="
  puts " Push commit and tag to Github:"
  puts "   $ git push origin && git push origin --tags"
end

def system!(*args)
  system(*args) || abort("\n== Command #{args.join(' ')} failed ==")
end

def add_jquery_to_path
  jquery_path = Dir.entries("#{Gem.paths.home}/gems/").detect { |dir| dir.match(/jquery-rails(.*)/) }
  $LOAD_PATH.unshift("#{Gem.paths.home}/gems/#{jquery_path}/vendor/") if jquery_path
end

task default: %w[lint:autocorrect spec]
