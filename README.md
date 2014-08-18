# GrapeSession (Project-State: Proposal)

Make Rails cookies based session handling available for grape. `session` method 
is added to the Endpoint classes.

The following classes will be monkey patched:

* `Grape::Endpoint`
* `Grape::Request`
* `ActionDispatch::Cookies::CookieJar`


## Installation

Add this line to your application's Gemfile:

    gem 'grape_session'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_session

## Usage

```ruby

class API < Grape::API
  include GrapeSession::Ext::API

  # Setup cookie settings
  GrapeCookies::Middleware::EnvSetup.configure do
     signed_cookie_salt 'signed cookie'
     encrypted_cookie_salt 'encrypted cookie'
     encrypted_signed_cookie_salt 'signed encrypted cookie'
     secret_token 'secret_token'
     secret_key_base 'secret base'
     cookies_serializer :json
  end

  # Setup session settings
  GrapeSession::Configuration.configure do
    # Rails specific ActionDispatch::Compatibility
    key '_grape_session_id' 
    # Rack::Session::Abstract::ID specific
    domain 'foo.com'
    path  '/'
    expire_after 2592000
    secure false
    httponly true
    defer false
    renew false
  end
  
  
  get '/test' do
    session['session_test'] = 'session_test_value'
  end

end


```

## Contributing

1. Fork it ( https://github.com/faber-lotto/grape_session/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
