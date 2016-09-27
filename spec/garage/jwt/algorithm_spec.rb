require 'spec_helper'

describe Garage::Jwt::Algorithm do
  where(:algorithm, :needs_common_key, :needs_public_key, :needs_private_key) do
    [
      [Garage::Jwt::Algorithm.none,   false,  false,  false],
      [Garage::Jwt::Algorithm.hs256,  true,   false,  false],
      [Garage::Jwt::Algorithm.hs384,  true,   false,  false],
      [Garage::Jwt::Algorithm.hs512,  true,   false,  false],
      [Garage::Jwt::Algorithm.rs256,  false,  true,   true],
      [Garage::Jwt::Algorithm.rs384,  false,  true,   true],
      [Garage::Jwt::Algorithm.rs512,  false,  true,   true],
      [Garage::Jwt::Algorithm.es256,  false,  true,   true],
      [Garage::Jwt::Algorithm.es384,  false,  true,   true],
      [Garage::Jwt::Algorithm.es512,  false,  true,   true],
    ]
  end

  with_them do
    subject { algorithm }
    its(:need_common_key?) { is_expected.to eq needs_common_key }
    its(:need_public_key?) { is_expected.to eq needs_public_key }
    its(:need_private_key?) { is_expected.to eq needs_private_key }
  end
end
