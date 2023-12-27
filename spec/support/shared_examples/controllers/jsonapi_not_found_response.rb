RSpec.shared_examples "a jsonapi not_found response" do
  it "returns not_found" do
    expect(response).to have_http_status(:not_found)
  end

  it "renders not_found error" do
    expect(JSON.parse(response.body)).to include(
      "errors" => array_including(
        a_hash_including(
          "status" => "404",
          "title" => "Not Found"
        )
      )
    )
  end
end
