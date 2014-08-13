require 'action_dispatch/middleware/cookies'

module GrapeSession
  module Ext
    module Request
      extend ActiveSupport::Concern

      included do

      end

      def cookie_jar
        env['action_dispatch.cookies'] ||= ActionDispatch::Cookies::CookieJar.build(self)
      end

      module ClassMethods
      end
    end
  end
end
