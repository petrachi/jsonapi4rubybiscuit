RSpec.shared_context "updatable jsonapi controller" do |action: :update|
  let(:role) {} unless method_defined?(:role)

  let(:do_before_request) {}
  let(:existing_resources_before_request) {}
  let(:resource_id) {}
  let(:body) { {} }
  let(:params) { {id: resource_id, **body} }

  before(:each) do
    do_before_request
    existing_resources_before_request
    request.headers["X-USER-ROLE"] = role
    patch(action, params: params)
  end
end
