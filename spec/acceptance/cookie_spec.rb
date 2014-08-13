require 'acceptance_spec_helper'
require 'grape'
require 'rack/test'

feature 'Encrypt a cookie session' do
  include Rack::Test::Methods

  let(:app) do

    Class.new(Grape::API) do
      include GrapeSession::Ext::API

      get '/test' do
        cookies.signed['test_signed'] = '1234'
        cookies['test_unsigned_signed'] = 'unsigned_1234'
      end

      get '/return' do
        {
          cookies: [cookies.signed['test_signed'], cookies['test_unsigned_signed']]
        }
      end
    end
  end

  let(:hostname) { Rack::Test::DEFAULT_HOST }
  let(:port) { 80 }
  let(:host) { "#{hostname}:#{port}" }

  let(:response_cookies) { rack_mock_session.cookie_jar }

  let(:verifier) do
    key_generator = last_request.env[ActionDispatch::Cookies::GENERATOR_KEY]
    signed_cookie_salt = last_request.env[ActionDispatch::Cookies::SIGNED_COOKIE_SALT]
    secret = key_generator.generate_key(signed_cookie_salt)
    ActiveSupport::MessageVerifier.new(secret, serializer: JSON)
  end

  def https?
    port == 443
  end

  scenario 'Cookie set signed' do
    get '/test'

    expect(last_response.status).to eq 200

    expect(response_cookies['test_signed']).not_to eq '1234'
    expect(verifier.verify(response_cookies['test_signed'])).to eq '1234'

    expect(response_cookies['test_unsigned_signed']).to eq 'unsigned_1234'

  end

  scenario 'Get signed cookie' do
    get '/test'

    get '/return'

    expect(last_response.body).to eq '{:cookies=>["1234", "unsigned_1234"]}'
  end
end
