# Garage::Jwt
[![Build Status](https://travis-ci.org/izumin5210/garage-jwt.svg?branch=master)](https://travis-ci.org/izumin5210/garage-jwt)
[![Test Coverage](https://codeclimate.com/github/izumin5210/garage-jwt/badges/coverage.svg)](https://codeclimate.com/github/izumin5210/garage-jwt/coverage)
[![Code Climate](https://codeclimate.com/github/izumin5210/garage-jwt/badges/gpa.svg)](https://codeclimate.com/github/izumin5210/garage-jwt)
[![Dependency Status](https://gemnasium.com/badges/github.com/izumin5210/garage-jwt.svg)](https://gemnasium.com/github.com/izumin5210/garage-jwt)
[![Gem Version](https://badge.fury.io/rb/garage-jwt.svg)](https://badge.fury.io/rb/garage-jwt)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://izumin.mit-license.org/2016)

[Garage](https://github.com/cookpad/garage) extension to use JWT as authentication strategy.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'garage-jwt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install garage-jwt

## Usage

In `config/initializer/garage.rb`:

```ruby
Garage.configuration.strategy = Garage::Strategy::Jwt

Garage::Jwt.configure do |c|
  c.algorithm = Garage::Jwt::Algorithm.hs256
  c.common_key = "secret key"

  # c.private_key = OpenSSL::PKey::RSA.generate 2048
  # c.public_key = c.private_key.public_key
end
```

The following cryptographic signing algorithms are available:

- NONE
  - `Garage::Jwt::Algorithm.none`
- HMAC
  - `Garage::Jwt::Algorithm.hs256` - HMAC using SHA-256 hash algorithm
  - `Garage::Jwt::Algorithm.hs384` - HMAC using SHA-384 hash algorithm
  - `Garage::Jwt::Algorithm.hs512` - HMAC using SHA-512 hash algorithm
- RSA
  - `Garage::Jwt::Algorithm.rs256` - RSA using SHA-256 hash algorithm
  - `Garage::Jwt::Algorithm.rs384` - RSA using SHA-384 hash algorithm
  - `Garage::Jwt::Algorithm.rs512` - RSA using SHA-512 hash algorithm
- ECDSA
  - `Garage::Jwt::Algorithm.rs256` - ECDSA using SHA-256 hash algorithm
  - `Garage::Jwt::Algorithm.rs384` - ECDSA using SHA-384 hash algorithm
  - `Garage::Jwt::Algorithm.rs512` - ECDSA using SHA-512 hash algorithm


### Generate token

```ruby
Garage::Jwt::Utils.encode(
  resource_owner_id: user.di,
  application_id: 128,
  scope: "read write",
  expired_at: Time.zone.now + 15.minutes
)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/izumin5210/garage-jwt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

