RSpec.shared_examples "a jsonapi restricted response" do |expected_responses:|
  expected_responses.each do |expected_response, examples|
    examples.each do |example|
      context example[:reason] do
        let(:resource_id) { instance_eval(&example[:resource_id]) }

        it_behaves_like "a jsonapi #{expected_response} response"
      end
    end
  end
end
