RSpec.shared_examples "a jsonapi unauthorized response" do
  it "returns unauthorized" do
    expect(response).to have_http_status(:unauthorized)
  end

  it "renders unauthorized error" do
    expect(JSON.parse(response.body)).to include(
      "errors" => array_including(
        a_hash_including(
          "status" => "401",
          "title" => "Unauthorized"
        )
      )
    )
  end
end
