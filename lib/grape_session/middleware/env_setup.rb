module GrapeSession
  module Middleware
    class EnvSetup
      def self.default_settings
        {
          signed_cookie_salt: 'signed cookie',
          encrypted_cookie_salt: 'encrypted cookie',
          encrypted_signed_cookie_salt: 'signed encrypted cookie',
          secret_token: 'secret_token',
          secret_key_base: 'secret base',
          cookies_serializer: :json
        }.freeze
      end

      def self.settings(new_settings)
        @settings_for_env = nil
        @caching_key_generator = nil
        @settings = default_settings.merge new_settings
      end

      def self.key_generator
        @caching_key_generator ||= begin
          key_generator = ActiveSupport::KeyGenerator.new(@settings[:secret_key_base], iterations: 1000)
          ActiveSupport::CachingKeyGenerator.new(key_generator)
        end
      end

      def self.settings_for_env
        @settings ||= default_settings

        @settings_for_env ||= {
          ActionDispatch::Cookies::GENERATOR_KEY => key_generator,
          ActionDispatch::Cookies::SIGNED_COOKIE_SALT => @settings[:signed_cookie_salt],
          ActionDispatch::Cookies::ENCRYPTED_COOKIE_SALT => @settings[:encrypted_cookie_salt],
          ActionDispatch::Cookies::ENCRYPTED_SIGNED_COOKIE_SALT => @settings[:encrypted_signed_cookie_salt],
          ActionDispatch::Cookies::SECRET_TOKEN => @settings[:secret_token],
          ActionDispatch::Cookies::SECRET_KEY_BASE => @settings[:secret_key_base],
          ActionDispatch::Cookies::COOKIES_SERIALIZER => @settings[:cookies_serializer]
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
