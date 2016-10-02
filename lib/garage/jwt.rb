require "jwt"
require "garage"

require "garage/jwt/version"
require "garage/jwt/algorithm"
require "garage/jwt/config"
require "garage/jwt/error"
require "garage/jwt/utils"
require "garage/strategy/jwt"

module Garage
  module Jwt
    extend Utils
  end
end
