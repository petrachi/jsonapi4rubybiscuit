RSpec.shared_examples "a jsonapi destroy response" do
  let(:expected_destroyed_resource) do
    described_class.act_as_jsonapi_model.find_by(id: resource_id)
  end

  it "destroys the resource and returns no content" do
    expect(expected_destroyed_resource).to be_nil
    expect(response).to have_http_status(:no_content)
  end
end
