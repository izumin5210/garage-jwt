require "rails_helper"

describe "Authorization", type: :request do
  include AuthenticatedContext

  let(:alice) { FactoryGirl.create(:user) }
  let(:bob) { FactoryGirl.create(:user) }
  let(:scopes) { "public read_private_post write_post sudo" }
  let(:resource_owner_id) { requester.id }
  let(:requester) { alice }

  let(:resource) { FactoryGirl.create(:post, user: alice) }
  let(:id) { resource.id }

  describe "GET /users/:user_id/posts/private" do
    let(:user_id) { alice.id }

    context "without valid scope" do
      let(:scopes) { "public" }
      it { is_expected.to eq 403 }
    end

    context "without authority" do
      let(:requester) { bob }
      it { is_expected.to eq 403 }
    end

    context "with valid scope" do
      it { is_expected.to eq 200 }
    end

    context "with another valid scope" do
      let(:scopes) { "public sudo" }
      it { is_expected.to eq 200 }
    end
  end

  describe "GET /posts/:id" do
    let(:requester) { alice }

    context "with valid requester" do
      it { is_expected.to eq 200 }
    end

    context "with another valid requester" do
      let(:requester) { bob }
      it { is_expected.to eq 200 }
    end
  end

  describe "GET /posts" do
    context "with stream=1 & no valid scope" do
      before { params[:stream] = 1 }
      let(:scopes) { "public" }
      it { is_expected.to eq 403 }
    end

    context "with stream=1 & valid scope" do
      it { is_expected.to eq 200 }
    end
  end

  describe "PUT /posts/:id" do
    before { params[:title] = "Bar" }

    context "with invalid requester" do
      let(:requester) { bob }
      it { is_expected.to eq 403 }
    end

    context "with response body option" do
      it "returns 200 with response body" do
        is_expected.to eq 200
        expect(JSON.parse(response.body)).to include(
          "id" => resource.id
        )
      end
    end
  end

  describe "POST /posts" do
    before { params[:title] = "test" }

    context "with valid condition" do
      it { is_expected.to eq 201 }
    end
  end

  describe "DELETE /posts/:id" do
    context "with response body option" do
      it "returns 200 with response body" do
        is_expected.to eq 200
        expect(JSON.parse(response.body)).to include(
          "id" => resource.id
        )
      end
    end

    context "with invalid requester" do
      let(:requester) { bob }
      it { is_expected.to eq 403 }
    end
  end
end
