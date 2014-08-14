module GrapeSession
  module Middleware
    class EnvSetup
      include GrapeSession::Configuration.module(
                  :signed_cookie_salt,
                  :encrypted_cookie_salt,
                  :encrypted_signed_cookie_salt,
                  :secret_token,
                  :secret_key_base,
                  :cookies_serializer,
                  session_options: [:key, :domain, :path, :expire_after, :secure, :httponly, :defer, :renew]
              )

      # setup defaults
      configure do
        signed_cookie_salt 'signed cookie'
        encrypted_cookie_salt 'encrypted cookie'
        encrypted_signed_cookie_salt 'signed encrypted cookie'
        secret_token 'secret_token'
        secret_key_base 'secret base'
        cookies_serializer :json

        session_options do
          key '_grape_session_id'
        end
      end

      def self.key_generator
        @caching_key_generator ||= begin
          key_generator = ActiveSupport::KeyGenerator.new(settings[:secret_key_base], iterations: 1000)
          ActiveSupport::CachingKeyGenerator.new(key_generator)
        end
      end

      def self.settings_for_env
        @settings_for_env ||= {
          ActionDispatch::Cookies::GENERATOR_KEY => key_generator,
          ActionDispatch::Cookies::SIGNED_COOKIE_SALT => settings[:signed_cookie_salt],
          ActionDispatch::Cookies::ENCRYPTED_COOKIE_SALT => settings[:encrypted_cookie_salt],
          ActionDispatch::Cookies::ENCRYPTED_SIGNED_COOKIE_SALT => settings[:encrypted_signed_cookie_salt],
          ActionDispatch::Cookies::SECRET_TOKEN => settings[:secret_token],
          ActionDispatch::Cookies::SECRET_KEY_BASE => settings[:secret_key_base],
          ActionDispatch::Cookies::COOKIES_SERIALIZER => settings[:cookies_serializer]
        }.freeze
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        env.merge!(self.class.settings_for_env)

        @app.call(env)
      end
    end
  end
end
