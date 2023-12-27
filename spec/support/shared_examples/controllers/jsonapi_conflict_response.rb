RSpec.shared_examples "a jsonapi conflict response" do
  it "returns conflict" do
    expect(response).to have_http_status(:conflict)
  end

  it "renders conflict error" do
    expect(JSON.parse(response.body)).to include(
      "errors" => array_including(
        a_hash_including(
          "status" => "409",
          "title" => "Conflict"
        )
      )
    )
  end
end
