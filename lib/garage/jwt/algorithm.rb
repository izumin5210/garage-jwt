module Garage
  module Jwt
    class Algorithm
      # https://github.com/jwt/ruby-jwt#algorithms-and-usage
      TYPES = {
        # NONE
        none: "none",

        # HMAC
        hs256: "HS256",
        hs384: "HS384",
        hs512: "HS512",

        # RSA
        rs256: "RS256",
        rs384: "RS384",
        rs512: "RS512",

        # ECDSA
        es256: "ES256",
        es384: "ES384",
        es512: "ES512",
      }.freeze

      class << self

        TYPES.each do |key, _|
          define_method key do
            Algorithm.new(key)
          end
        end
      end

      def need_common_key?
        %i(hs256 hs384 hs512).include?(@type_key)
      end

      def need_public_key?
        %i(rs256 rs384 rs512 es256 es384 es512).include?(@type_key)
      end
 
      def need_private_key?
        need_public_key?
      end

      def none?
        @type_key == :none
      end

      def type
        TYPES[@type_key]
      end

      private

      def initialize(type_key)
        @type_key = type_key
      end
    end
  end
end
