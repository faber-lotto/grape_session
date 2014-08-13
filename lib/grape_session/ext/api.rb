require 'action_dispatch/middleware/cookies'
require 'action_dispatch/middleware/session/cookie_store'

module GrapeSession
  module Ext
    module API
      extend ActiveSupport::Concern

      included do

        use GrapeSession::Middleware::EnvSetup
        use ActionDispatch::Cookies
        use ActionDispatch::Session::CookieStore, GrapeSession::Middleware::EnvSetup.settings[:session_options]

      end

      module ClassMethods
      end
    end
  end
end
