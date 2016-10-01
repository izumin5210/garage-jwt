module AuthenticatedContext
  extend ActiveSupport::Concern

  included do
    let(:now) { Time.parse("20160926T123456") }

    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:user) { FactoryGirl.create(:user) }
    let(:resource_owner_id) { user.id }
    let(:application_id) { rand(128) }
    let(:scopes) { "read meta" }
    let(:expired_at) { now + 15.minutes }

    let(:common_key) { SecureRandom.hex(256) }
    let(:algorithm) { Garage::Jwt::Algorithm.hs256 }

    let(:access_token) do
      Garage::Jwt::Utils.encode(
        resource_owner_id: resource_owner_id,
        application_id: application_id,
        expired_at: expired_at,
        scope: scopes
      )
    end

    before do
      headers["Accept"] = "application/json"
      headers["Authorization"] = "Bearer #{access_token}"
    end

    before do
      Garage::Jwt::Config::Builder.new do |c|
        c.algorithm = algorithm
        c.common_key = common_key
      end
    end
  end
end
