require 'rails_helper'

describe "Authentication", type: :request do
  include AuthenticatedContext

  describe "GET /echo" do
    context  "without valid token" do
      let(:access_token) { "test.dummy.token" }

      it "returns 401" do
        is_expected.to eq 401
        expect(JSON.parse(response.body)).to be_key("error")
      end
    end

    context "with valid access token" do
      it { is_expected.to eq 200 }
    end
  end
end
