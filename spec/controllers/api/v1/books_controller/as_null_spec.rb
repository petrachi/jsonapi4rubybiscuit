RSpec.describe API::V1::BooksController, "as_null", type: :controller do
  let(:role) { "null" }

  describe "#index" do
    include_context "listable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
    end

    it_behaves_like "a jsonapi unauthorized response"
  end

  describe "#show" do
    include_context "showable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi unauthorized response"
  end

  describe "#create" do
    include_context "creatable jsonapi controller" do
      let(:existing_resources_before_request) {}
    end

    it_behaves_like "a jsonapi unauthorized response"
  end

  describe "#update" do
    include_context "updatable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi unauthorized response"
  end

  describe "#destroy" do
    include_context "destroyable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi unauthorized response"
  end
end
