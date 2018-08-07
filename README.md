# Cfa::Styleguide

Gem including base styles and javascript for Code for America products, for use in Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cfa-styleguide'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cfa-styleguide

## Usage

1. Add `@import 'cfa_styleguide_main';` to application.scss.

1. Add `//= require cfa_styleguide_main` to application.js.

1. Add `mount Cfa::Styleguide::Engine => "/cfa"` to routes.rb.

1. Visit `<your hostname>/cfa/styleguide` to view the styleguide

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Updating the Styleguide

1. Copy `app/assets` from [gcf-backend](https://github.com/codeforamerica/gcf-backend) into `app/assets` here.

1. Rename `main.scss` to `cfa_styleguide_main.scss`

1. Add `@import 'prism';` in the list of vendor imports in `cfa_styleguide_main.scss`

1. Rename `application.js` to `cfa_styleguide_main.js`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/codeforamerica/cfa-styleguide-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cfa::Styleguide project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/codeforamerica/cfa-product-styleguide/blob/master/CODE_OF_CONDUCT.md).
