# Honeycrisp Design System

A gem including base styles and javascript for Code for America products, for use in Rails applications.

View the current version of the styleguide at [https://honeycrisp.herokuapp.com](https://honeycrisp.herokuapp.com).

## Contributing

We are not currently seeking contributions from the public.

If you have any thoughts or questions about the project, get in touch at <a href="mailto:styleguide@codeforamerica.org">styleguide@codeforamerica.org</a> or the `#cfa-design-toolkit` channel in the Code for America Slack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cfa-styleguide', git: 'https://github.com/codeforamerica/honeycrisp-gem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cfa-styleguide

## Upgrading

The styleguide gem is pre-1.0.0 release, and should be considered as being in beta.

We do our best to keep things stable between minor version releases; 
however, decisions about deprecation and breaking changes are made given our knowledge about
the usage of the gem by active projects maintained and developed by Code for America staff.

**When upgrading the gem between patch versions** (e.g. 0.7.1 to 0.7.2), expect no breakage.

**When upgrading the gem between minor versions** (e.g. 0.7.1 to 0.8.0), be sure to review the [changelog](./CHANGELOG.md) and [migration guide](./MIGRATING.md).

If you encounter any breaking changes that we have not documented, please let us know by opening an issue!

## Usage

1. Add `@import 'cfa_styleguide_main';` to application.scss.

1. Add `//= require cfa_styleguide_main` to application.js.

1. Add `mount Cfa::Styleguide::Engine => "/cfa"` to routes.rb.

1. Visit any of the following routes to view the styleguides:

    ```
    `<your hostname>/cfa/styleguide`
    `<your hostname>/cfa/styleguide/cbo-dashboard`
    `<your hostname>/cfa/styleguide/cbo-analytics`
    `<your hostname>/cfa/styleguide/current`
    `<your hostname>/cfa/styleguide/custom-docs`
    ```

1. (Optional) To override the styleguide's variables (e.g. use `#000000` for `$color-background` rather than as defined in the gem), require your own file that redefines the variables in your application.scss like so:

    ```scss
    @import 'my_variable_file'
    @import 'cfa_styleguide_main'

    ```


1. (Optional) To use variables provided by the style guide gem remove `require_tree` directives from your `application.scss` and use use `@import` statements instead ([from stack overflow](https://stackoverflow.com/questions/6269420/sass-global-variables-not-being-passed-to-partials/9055230#9055230))

    ```scss
    # do not use
    *= require_tree .
    ```
    
    ```scss
    # use instead
    @import 'things_to_import'
    ```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You must install Chromedriver to run tests; on MacOS with Homebrew, run `brew bundle install`

Run `bin/rails s` to start a webserver with a test app that has the engine mounted, then visit `http://localhost:3000`.

### Overriding this gem locally in another project

If the gem is being used in another project's Gemfile, the source can be locally overridden within the other project's Gemfile in two ways:

1. Change the bundler configuration to use the local gem repository

    In the terminal, run `bundle config local.cfa-styleguide /path/to/honeycrisp-gem`

    To install this gem onto your local machine, run `bundle exec rake install`.
  
    When finished with development, remove this configuration by running `bundle config --delete local.cfa-styleguide` and `bundle install`
  
1. Change your Gemfile to point to the local gem repository 

    Alternatively, you can change host project's `Gemfile` to point to a local copy of this repository. For example, changing:

    ```
    gem 'cfa-styleguide', '~> 0.7', github: 'codeforamerica/honeycrisp-gem'
    ```
    to
    ```
    gem 'cfa-styleguide', '~> 0.7', path: '../honeycrisp-gem'
    ```
    
    where `../honeycrisp-gem` is the path (relative or absolute) to this repo on the local filesystem.
    
    After updating the `Gemfile` with these changes, you will need to run `bundle install`.
    
    When finish, just revert the Gemfile to the original version and `bundle install` again.


### Running tests

A small test suite is available—please add to it!

To run, run `rake` or `rspec spec`.

### Releasing new gem versions

To release a new version, on `master` branch:
* Update the version number in `version.rb` using [semantic versioning](https://semver.org/)
* `bundle install` to update the Gemfile.lock
* Generate an addition to the [changelog](./CHANGELOG.md) using `bundle exec rake changelog`. (Note: you will need to provide a [Github token with public repo access](https://github.com/github-changelog-generator/github-changelog-generator#github-token)).
* If updating the minor version, update the [migration guide](./MIGRATING.md) with any breaking changes and suggestions for what to do about them. If no breaking changes, just add 'no breaking changes'. 
* Review, edit as necessary, and commit including the version update.
* Run `gem_push=false bundle exec rake release`, which will create a git tag for the version, and push git commits and tags to Github. In the future, this will also push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in this project’s codebase, issue trackers, chat rooms and mailing lists is expected to follow the Code for America [code of conduct](https://brigade.codeforamerica.org/about/code-of-conduct).
