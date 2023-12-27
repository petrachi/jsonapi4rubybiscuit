RSpec.shared_examples "a jsonapi unprocessable response" do
  let(:expected_unprocessable_errors) { {} }

  let(:expected_unprocessable_errors_matcher) do
    a_collection_including(
      *expected_unprocessable_errors.map do |pointer, code|
        a_hash_including(
          "status" => "422",
          "source" => {
            "pointer" => ("/data/#{pointer}" if pointer.present?).to_s,
          },
          "title" => "Unprocessable Entity",
          "detail" => anything,
          "code" => code
        )
      end
    )
  end

  it "returns unprocessable and renders unprocessable errors" do
    expect(JSON.parse(response.body)).to include("errors" => expected_unprocessable_errors_matcher)
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
