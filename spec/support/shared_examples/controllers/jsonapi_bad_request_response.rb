RSpec.shared_examples "a jsonapi bad request response" do
  it "returns bad request" do
    expect(response).to have_http_status(:bad_request)
  end

  it "renders bad request error" do
    expect(JSON.parse(response.body)).to include(
      "errors" => array_including(
        a_hash_including(
          "status" => "400",
          "title" => "Bad Request"
        )
      )
    )
  end
end
