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

        def valid?
          @config.algorithm.present? &&
            @config.algorithm.is_a?(Garage::Jwt::Algorithm) &&
            (
              (!@config.algorithm.need_common_key? || @config.common_key.present?) &&
              (!@config.algorithm.need_public_key? || @config.public_key.present?) &&
              (!@config.algorithm.need_private_key? || @config.private_key.present?)
            )
        end

        def build
          if valid?
            @config
          else
            fail Garage::Jwt::InitializeError
          end
        end
      end
    end
  end
end
