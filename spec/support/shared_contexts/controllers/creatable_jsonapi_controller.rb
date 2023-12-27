RSpec.shared_context "creatable jsonapi controller" do
  let(:role) {} unless method_defined?(:role)

  let(:do_before_request) {}
  let(:existing_resources_before_request) {}
  let(:body) { {} }
  let(:params) { body }

  before(:each) do
    do_before_request
    existing_resources_before_request
    request.headers["X-USER-ROLE"] = role
    post :create, params: params
  end
end
