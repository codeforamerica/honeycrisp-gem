# Cfa::Styleguide

Gem including base styles and javascript for Code for America products, for use in Rails applications.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. 

Run `bin/rails s` to start a webserver with a test app that has the engine mounted, then visit `http://localhost:3000/cfa/styleguide`. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If the gem is being used in another project's Gemfile, the source can be locally overridden within the other project's Gemfile by running `bundle config local.cfa-styleguide /path/to/cfa-styleguide-gem`, and undone with `bundle config --delete local.cfa-styleguide`

To install this gem onto your local machine, run `bundle exec rake install`. 

### Running tests

A small test suite is available—please add to it!

To run, run `rake` or `rspec spec`.

### Releasing new versions
    
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/codeforamerica/cfa-styleguide-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cfa::Styleguide project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/codeforamerica/cfa-product-styleguide/blob/master/CODE_OF_CONDUCT.md).
