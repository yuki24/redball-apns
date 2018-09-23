# Redball::Apns [![Build Status](https://travis-ci.org/yuki24/redball-apns.svg?branch=master)](https://travis-ci.org/yuki24/redball-apns)

Redball is a production-ready APNs (Apple Push Notifiaction Service) client.

 * **HTTP/2 done right**: The client ully utilizes HTTP/2's fantastic features, single persistent connection and multiplexing.
 * **Least needed dependency**: The only dependency the gem depends on is the [curb gem](https://github.com/taf2/curb), a wrapper around [libcurl](https://curl.haxx.se/libcurl/), which has been installed on nearly a billion of machines and deviscs worldwide.
 * **Proper error handling**: Unlike other gems, the redball gem properly delegates connection errors to the thread that made a request rather than crashing the whole process or squashing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redball-apns'
```

Or install it yourself as:

    $ gem install redball-apns

## Usage

### JWT-based authentication

```ruby
require 'redball/apns'

client = Redball::Apns.jwt(
  environment: :production,
  cert_path:   "absolute/path/to/cert.p8",
  team_id:     "TEAM_ID",
  key_id:      "KEY_ID",
)

body = {
  aps: {
    alert: {
      title: "Update",
      body: "Your weekly summary is ready"
    }
  },
  badge: 1,
  sound: "bingbong.aiff"
}

response = client.push(@device_token, body, headers: { 'apns-topic' => 'net.yukinishijima' })

response.status # => 200
```

### Certificate-based authentication

TODO: Write usage instructions here

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redball-apns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Redball::Apns project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/redball-apns/blob/master/CODE_OF_CONDUCT.md).
