RSpec.shared_examples "a jsonapi forbidden response" do
  it "returns forbidden" do
    expect(response).to have_http_status(:forbidden)
  end

  it "renders forbidden error" do
    expect(JSON.parse(response.body)).to include(
      "errors" => array_including(
        a_hash_including(
          "status" => "403",
          "title" => "Forbidden"
        )
      )
    )
  end
end
