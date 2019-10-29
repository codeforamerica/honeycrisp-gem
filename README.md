# Code for America Styleguide

A gem including base styles and javascript for Code for America products, for use in Rails applications.

View the current version of the styleguide at [https://cfa-styleguide.herokuapp.com](https://cfa-styleguide.herokuapp.com).

## Contributing

We are not currently seeking contributions from the public.

If you have any thoughts or questions about the project, get in touch at <a href="mailto:styleguide@codeforamerica.org">styleguide@codeforamerica.org</a> or the `#cfa-design-toolkit` channel in the Code for America Slack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cfa-styleguide', git: 'https://github.com/codeforamerica/cfa-styleguide-gem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cfa-styleguide

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

    In the terminal, run `bundle config local.cfa-styleguide /path/to/cfa-styleguide-gem`

    To install this gem onto your local machine, run `bundle exec rake install`.
  
    When finished with development, remove this configuration by running `bundle config --delete local.cfa-styleguide` and `bundle install`
  
1. Change your Gemfile to point to the local gem repository 

    Alternatively, you can change host project's `Gemfile` to point to a local copy of this repository. For example, changing:

    ```
    gem 'cfa-styleguide', '~> 0.7', github: 'codeforamerica/cfa-styleguide-gem'
    ```
    to
    ```
    gem 'cfa-styleguide', '~> 0.7', path: '../cfa-styleguide-gem'
    ```
    
    where `../cfa-styleguide-gem` is the path (relative or absolute) to this repo on the local filesystem.
    
    After updating the `Gemfile` with these changes, you will need to run `bundle install`.
    
    When finish, just revert the Gemfile to the original version and `bundle install` again.


### Running tests

A small test suite is available—please add to it!

To run, run `rake` or `rspec spec`.

### Releasing new gem versions

To release a new version, on `master` branch:
* Update the version number in `version.rb` using [semantic versioning](https://semver.org/)
* `bundle install` to update the Gemfile.lock
* Generate a changelog using `bundle exec rake changelog`. (Note: you will need to provide a [Github token with public repo access](https://github.com/github-changelog-generator/github-changelog-generator#github-token)). 
* Review, edit as necessary, and commit including the version update.
* Run `bundle exec rake release`, which will create a git tag for the version, and push git commits and tags to Github. In the future, this will also push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in this project’s codebase, issue trackers, chat rooms and mailing lists is expected to follow the Code for America [code of conduct](https://brigade.codeforamerica.org/about/code-of-conduct).
