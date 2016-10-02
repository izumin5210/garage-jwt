require 'rails_helper'

describe Garage::Jwt::Config do

  describe Garage::Jwt::Config::Builder do
    describe '#build' do
      context 'with valid params' do
        subject { builder.build }

        let(:builder) do
          Garage::Jwt::Config::Builder.new do |c|
            c.algorithm = Garage::Jwt::Algorithm.hs256
            c.common_key = "test_key"
          end
        end

        it { is_expected.to be_a Garage::Jwt::Config }
      end

      context 'with invalid algorithm' do
        subject { -> { builder.build } }

        let(:builder) do
          Garage::Jwt::Config::Builder.new do |c|
            c.algorithm = "hs256"
            c.public_key = "test_key"
          end
        end

        it { is_expected.to raise_error(Garage::Jwt::InitializeError, "Invalid algorithm") }
      end

      context 'with invalid keys' do
        subject { -> { builder.build } }

        let(:builder) do
          Garage::Jwt::Config::Builder.new do |c|
            c.algorithm = Garage::Jwt::Algorithm.rs256
            c.public_key = "test_key"
          end
        end

        it { is_expected.to raise_error(Garage::Jwt::InitializeError, "Invalid keys") }
      end
    end
  end
end

