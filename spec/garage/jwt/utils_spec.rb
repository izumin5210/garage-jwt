require 'rails_helper'

describe Garage::Jwt::Utils do
  before { Timecop.freeze(now) }
  after { Timecop.return }

  let(:now) { Time.parse("20160926T123456") }
  let(:user_id) { 2 }
  let(:application_id) { 5 }
  let(:scope) { %w(read) }
  let(:expired_at) { now + 15.minutes }
  let(:token) do
    Garage::Jwt.encode_token(
      resource_owner_id: user_id,
      application_id: application_id,
      scope: scope,
      expired_at: expired_at
    )
  end

  shared_examples_for 'a valid decoder' do
    subject { Garage::Jwt.decode_token(token, "bearer") }

    context 'with valid token' do
      its([:resource_owner_id]) { is_expected.to eq user_id }
      its([:scope]) { is_expected.to eq scope.join(" ") }
      its([:expired_at]) { is_expected.to eq expired_at.to_i }
      its([:token]) { is_expected.to eq token }
    end

    context 'with invalid format token' do
      let(:token) { "invalid_token" }
      it { is_expected.to be_nil }
    end

    context 'with expired token' do
      let(:expired_at) { now - 15.minutes }

      its([:resource_owner_id]) { is_expected.to eq user_id }
      its([:scope]) { is_expected.to eq scope.join(" ") }
      its([:expired_at]) { is_expected.to eq expired_at.to_i }
      its([:token]) { is_expected.to eq token }
    end
  end

  context 'when not using algorithms for cryptographic signing'do
    before do
      Garage::Jwt.configure do |c|
        c.algorithm = Garage::Jwt::Algorithm.none
      end
    end

    it_behaves_like 'a valid decoder'
  end

  context 'when using HMAC algorithm for cryptographic signing'do
    before do
      Garage::Jwt.configure do |c|
        c.algorithm = Garage::Jwt::Algorithm.hs256
        c.common_key = "testkey"
      end
    end

    it_behaves_like 'a valid decoder'
  end

  context 'when using RSA algorithm for cryptographic signing'do
    before do
      Garage::Jwt.configure do |c|
        c.algorithm = Garage::Jwt::Algorithm.rs256
        c.private_key = OpenSSL::PKey::RSA.generate 2048
        c.public_key = c.private_key.public_key
      end
    end

    it_behaves_like 'a valid decoder'
  end

  context 'when using ECDSA algorithm for cryptographic signing'do
    before do
      Garage::Jwt.configure do |c|
        c.algorithm = Garage::Jwt::Algorithm.es256
        c.private_key = OpenSSL::PKey::EC.new 'prime256v1'
        c.private_key.generate_key
        c.public_key = OpenSSL::PKey::EC.new c.private_key
        c.public_key.private_key = nil
      end
    end

    it_behaves_like 'a valid decoder'
  end

end
