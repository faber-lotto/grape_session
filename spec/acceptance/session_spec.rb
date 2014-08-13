require 'acceptance_spec_helper'
require 'grape'
require 'rack/test'

feature 'Use an encrypted session' do
  include Rack::Test::Methods

  let(:app) do

    Class.new(Grape::API) do
      include GrapeSession::Ext::API

      get '/test' do
        session['session_test'] = 'session_test_value'
      end

      get '/return' do
        { session: session.to_hash }
      end
    end
  end

  let(:hostname) { Rack::Test::DEFAULT_HOST }
  let(:port) { 80 }
  let(:host) { "#{hostname}:#{port}" }

  let(:response_cookies) { rack_mock_session.cookie_jar }

  let(:decryptor) do
    key_generator = last_request.env[ActionDispatch::Cookies::GENERATOR_KEY]
    encrypted_cookie_salt = last_request.env[ActionDispatch::Cookies::ENCRYPTED_COOKIE_SALT]
    encrypted_signed_cookie_salt = last_request.env[ActionDispatch::Cookies::ENCRYPTED_SIGNED_COOKIE_SALT]
    sign_secret  = key_generator.generate_key(encrypted_signed_cookie_salt)
    secret = key_generator.generate_key(encrypted_cookie_salt)
    ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: JSON)
  end

  def https?
    port == 443
  end

  scenario 'Session variable set signed' do
    get '/test'

    expect(last_response.status).to eq 200

    expect(decryptor.decrypt_and_verify response_cookies['_session_id']).to include('session_test' => 'session_test_value')
  end

  scenario 'Get session' do
    get '/test'

    get '/return'

    expect(last_response.body).to include('"session_test"=>"session_test_value"')
  end
end
