module Garage
  module Jwt
    module Utils
      def encode_token(resource_owner_id:, application_id:, expired_at:, scope:)
        payload = {
          sub: resource_owner_id,
          aud: application_id,
          exp: expired_at.to_i,
          scope: (scope.is_a?(Array) ? scope.join(" ") : scope)
        }
        JWT.encode(payload, private_key, algorithm.type)
      end

      def decode_token(token, token_type)
        payload, _ = JWT.decode(token, public_key, verify?, decoding_options)
        { token: token,
          token_type: token_type,
          scope: payload["scope"],
          application_id: payload["aud"],
          resource_owner_id: payload["sub"],
          expired_at: payload["exp"],
          revoked_at: nil
        }
      rescue JWT::DecodeError => e
        nil
      end

      private

      def configuration
        Garage::Jwt.configuration
      end

      def algorithm
        configuration.algorithm
      end

      def public_key
        algorithm.need_public_key? ? configuration.public_key : common_key
      end

      def private_key
        algorithm.need_public_key? ? configuration.private_key : common_key
      end

      def common_key
        algorithm.need_common_key? ? configuration.common_key : nil
      end

      def decoding_options
        { algorithm: algorithm.type, verify_expiration: false }
      end

      def verify?
        !algorithm.none?
      end
    end
  end
end
