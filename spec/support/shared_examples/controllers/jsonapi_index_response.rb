RSpec.shared_examples "a jsonapi index response" do
  let(:params) { super().reverse_merge({include: expected_relationships.join(",")}) }

  let(:expected_resources_in_response) { [] }
  let(:expected_attributes) { [] }
  let(:expected_relationships) { [] }
  let(:expected_serialized_data) do
    ->(resource) {
      data = {"id" => resource.id.to_s}

      if expected_attributes.present?
        data["attributes"] = match(
          expected_attributes.each_with_object({}) do |attribute, acc|
            acc[attribute] = anything
          end
        )
      end

      if expected_relationships.present?
        data["relationships"] = match(
          expected_relationships.each_with_object({}) do |relationship, acc|
            acc[relationship] = anything
          end
        )
      end
      data
    }
  end

  let(:expected_serialized_response) do
    {
      "data" => contain_exactly(*expected_resources_in_response.map do |resource|
        a_hash_including(expected_serialized_data[resource])
      end),
    }
  end

  it "returns many serialized resources" do
    expect(JSON.parse(response.body)).to include(expected_serialized_response)
  end
end
