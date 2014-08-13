module GrapeSession
  module Ext
    module Endpoint
      extend ActiveSupport::Concern

      included do
      end

      def cookies
        request.cookie_jar
      end

      def session
        request.session
      end

      module ClassMethods
      end
    end
  end
end
