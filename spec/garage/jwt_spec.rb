require 'rails_helper'

describe Garage::Jwt do
  it 'has a version number' do
    expect(Garage::Jwt::VERSION).not_to be nil
  end
end
