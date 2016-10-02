module Garage
  module Strategy
    module Jwt
      extend ActiveSupport::Concern
      include Garage::Jwt::Utils

      included do
        before_action :verify_auth, if: -> (_) { verify_permission? }
      end

      def verify_permission?
        true
      end

      def access_token
        if defined?(@access_token)
          @access_token
        else
          token_type, token = request.authorization.try { |h| h.split(/\s+/) }
          decoded_token = decode_token(token, token_type)
          if decoded_token.present?
            @access_token = Garage::Strategy::AccessToken.new(decoded_token)
          else
            nil
          end
        end
      end
    end
  end
end

