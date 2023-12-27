RSpec.describe API::V1::BooksController, "as_admin", type: :controller do
  let(:role) { "guest" }
  let(:book) { create(:book) }
  let(:private_book) { create(:book, price: 1200) }

  describe "#index" do
    include_context "listable jsonapi controller" do
      let(:existing_resources_before_request) { [book, private_book] }
    end

    it_behaves_like "a jsonapi index response" do
      let(:expected_resources_in_response) { [book] }
      let(:expected_attributes) do
        %w[name price]
      end
      let(:expected_relationships) do
        %w[author]
      end
    end
  end

  describe "#show" do
    include_context "showable jsonapi controller" do
      let(:existing_resources_before_request) { [book, private_book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi restricted response", expected_responses: {
      not_found: [
        {reason: "with an non-existing book_id", resource_id: proc { 100_001 }},
        {reason: "with an private book_id", resource_id: proc { private_book.id }},
      ],
    }

    it_behaves_like "a jsonapi show response" do
      let(:expected_resource_in_response) { book }
      let(:expected_attributes) do
        %w[name price]
      end
      let(:expected_relationships) do
        %w[author]
      end
    end
  end

  describe "#create" do
    include_context "creatable jsonapi controller" do
      let(:existing_resources_before_request) {}
    end

    it_behaves_like "a jsonapi forbidden response"
  end

  describe "#update" do
    include_context "updatable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi restricted response", expected_responses: {
      not_found: [
        {reason: "with an non-existing book_id", resource_id: proc { 100_001 }},
      ],
    }

    context "without body" do
      let(:body) { {} }

      it_behaves_like "a jsonapi bad request response"
    end

    context "with conflicting body" do
      let(:body) { {data: {type: "book", id: resource_id.next}} }

      it_behaves_like "a jsonapi conflict response"
    end

    context "with missing params" do
      let(:body) { {data: {id: resource_id, type: "book", attributes:}} }

      let(:attributes) do
        {
          "name" => nil,
        }
      end

      it_behaves_like "a jsonapi unprocessable response" do
        let(:expected_unprocessable_errors) do
          {
            "attributes/name" => "blank",
          }
        end
      end
    end

    context "with valid body" do
      let(:body) { {data: {id: resource_id, type: "book"}} }
      let(:author) { create :author }
      let(:publisher) { create :publisher }

      it_behaves_like "a jsonapi update response" do
        let(:attributes) do
          {
            "name" => "Name",
          }
        end
      end
    end
  end

  describe "#destroy" do
    include_context "destroyable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi forbidden response"
  end
end
