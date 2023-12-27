RSpec.describe API::V1::BooksController, "as_admin", type: :controller do
  let(:role) { "admin" }
  let(:book) { create(:book) }

  describe "#index" do
    include_context "listable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
    end

    it_behaves_like "a jsonapi index response" do
      let(:expected_resources_in_response) { [book] }
      let(:expected_attributes) do
        %w[name price author_id publisher_id created_at updated_at]
      end
      let(:expected_relationships) do
        %w[author publisher]
      end
    end
  end

  describe "#show" do
    include_context "showable jsonapi controller" do
      let(:existing_resources_before_request) { [book] }
      let(:resource_id) { book.id }
    end

    it_behaves_like "a jsonapi restricted response", expected_responses: {
      not_found: [
        {reason: "with an non-existing book_id", resource_id: proc { 100_001 }},
      ],
    }

    it_behaves_like "a jsonapi show response" do
      let(:expected_resource_in_response) { book }
      let(:expected_attributes) do
        %w[name price author_id publisher_id created_at updated_at]
      end
      let(:expected_relationships) do
        %w[author publisher]
      end
    end
  end

  describe "#create" do
    include_context "creatable jsonapi controller" do
      let(:existing_resources_before_request) {}
    end

    context "without body" do
      let(:body) { {} }

      it_behaves_like "a jsonapi bad request response"
    end

    context "with conflicting body" do
      let(:body) { {data: {type: "other"}} }

      it_behaves_like "a jsonapi conflict response"
    end

    context "with missing params" do
      let(:body) { {data: {type: "book"}} }

      it_behaves_like "a jsonapi unprocessable response" do
        let(:expected_unprocessable_errors) do
          {
            "attributes/name" => "blank",
            "attributes/price" => "not_a_number",
            "relationships/author" => "required",
            "relationships/publisher" => "required",
          }
        end
      end
    end

    context "with valid body" do
      let(:body) { {data: {type: "book", attributes:, relationships:}} }
      let(:author) { create :author }
      let(:publisher) { create :publisher }

      it_behaves_like "a jsonapi create response" do
        let(:attributes) do
          {
            "name" => "Name",
            "price" => 1200,
          }
        end
        let(:relationships) do
          {
            "author" => {"data" => {"type" => "author", "id" => author.id.to_s}},
            "publisher" => {"data" => {"type" => "publisher", "id" => publisher.id.to_s}},
          }
        end
      end
    end
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
      let(:body) { {data: {id: resource_id, type: "book", attributes:, relationships:}} }

      let(:attributes) do
        {
          "name" => nil,
          "price" => nil,
        }
      end

      let(:relationships) do
        {
          "author" => nil,
          "publisher" => nil,
        }
      end

      it_behaves_like "a jsonapi unprocessable response" do
        let(:expected_unprocessable_errors) do
          {
            "attributes/name" => "blank",
            "attributes/price" => "not_a_number",
            "relationships/author" => "required",
            "relationships/publisher" => "required",
          }
        end
      end
    end

    context "with invalid params" do
      let(:body) { {data: {id: resource_id, type: "book", attributes:}} }

      let(:attributes) do
        {
          "price" => -500,
        }
      end

      it_behaves_like "a jsonapi unprocessable response" do
        let(:expected_unprocessable_errors) do
          {
            "attributes/price" => "greater_than",
          }
        end
      end
    end

    context "with valid body" do
      let(:body) { {data: {id: resource_id, type: "book", relationships: relationships}} }
      let(:author) { create :author }
      let(:publisher) { create :publisher }

      it_behaves_like "a jsonapi update response" do
        let(:attributes) do
          {
            "name" => "Name",
            "price" => 1200,
          }
        end
        let(:relationships) do
          {
            "author" => {"data" => {"type" => "author", "id" => author.id.to_s}},
            "publisher" => {"data" => {"type" => "publisher", "id" => publisher.id.to_s}},
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

    it_behaves_like "a jsonapi restricted response", expected_responses: {
      not_found: [
        {reason: "with an non-existing book_id", resource_id: proc { 100_001 }},
      ],
    }

    it_behaves_like "a jsonapi destroy response"
  end
end
