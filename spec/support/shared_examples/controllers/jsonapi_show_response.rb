RSpec.shared_examples "a jsonapi show response" do
  let(:params) { super().reverse_merge({include: expected_relationships.join(",")}) }

  let(:expected_resource_in_response) {}
  let(:expected_attributes) { [] }
  let(:expected_relationships) { [] }
  let(:expected_serialized_data) do
    data = {
      "id" => expected_resource_in_response&.id.to_s,
      "attributes" => match(
        expected_attributes.each_with_object({}) do |attribute, acc|
          acc[attribute] = anything
        end
      ),
    }
    if expected_relationships.present?
      data["relationships"] = match(
        expected_relationships.each_with_object({}) do |relationship, acc|
          acc[relationship] = anything
        end
      )
    end
    data
  end

  let(:expected_serialized_response) do
    {"data" => a_hash_including(expected_serialized_data)}
  end

  it "returns serialized resource" do
    expect(JSON.parse(response.body)).to include(expected_serialized_response)
  end
end
