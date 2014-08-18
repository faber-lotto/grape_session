require 'action_dispatch/middleware/cookies'
require 'action_dispatch/middleware/session/cookie_store'

module GrapeSession
  module Ext
    module API
      extend ActiveSupport::Concern

      include GrapeCookies::Ext::API

      included do

        use ActionDispatch::Session::CookieStore, GrapeSession::Configuration.settings.dup

      end

      module ClassMethods
      end
    end
  end
end
