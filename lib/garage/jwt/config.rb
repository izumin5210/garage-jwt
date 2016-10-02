module Garage
  module Jwt
    def self.configure(&block)
      @config = Config::Builder.new(&block).build
    end

    def self.configuration
      @config ||= configure {}
    end

    class Config
      attr_accessor :common_key, :public_key, :private_key, :algorithm

      class Builder
        def initialize(&block)
          @config = Config.new
          block.call(@config)
        end

        def build
          validate!
          @config
        end

        private

        def validate!
          unless valid_algorithm?
            fail Garage::Jwt::InitializeError.new("Invalid algorithm")
          end
          unless valid_keys?
            fail Garage::Jwt::InitializeError.new("Invalid keys")
          end
        end

        def valid_algorithm?
          @config.algorithm.present? &&
            @config.algorithm.is_a?(Garage::Jwt::Algorithm)
        end

        def valid_keys?
          (!@config.algorithm.need_common_key? || @config.common_key.present?) &&
            (!@config.algorithm.need_public_key? || @config.public_key.present?) &&
            (!@config.algorithm.need_private_key? || @config.private_key.present?)
        end
      end
    end
  end
end
