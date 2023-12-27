RSpec.shared_examples "a jsonapi create response" do
  let(:attributes) { {} }
  let(:relationships) { {} }

  let(:expected_serialized_resource_attributes) { attributes }
  let(:expected_serialized_resource_relationships) do
    relationships.deep_dup.transform_values do |data|
      a_hash_including(data)
    end
  end
  let(:expected_serialized_resource) do
    a_hash_including(
      "attributes" => a_hash_including(expected_serialized_resource_attributes),
      "relationships" => a_hash_including(expected_serialized_resource_relationships)
    )
  end

  let(:expected_persisted_resource) do
    described_class.act_as_jsonapi_model.find_by(id: JSON.parse(response.body)["data"]["id"])
  end
  let(:expected_persisted_resource_attributes) { attributes }

  it "returns OK, persists the ressource and renders it serialized" do
    expect(JSON.parse(response.body)).to include("data" => expected_serialized_resource)
    expect(response).to have_http_status(:ok)
    expect(expected_persisted_resource&.attributes).to include(expected_persisted_resource_attributes)
  end
end
