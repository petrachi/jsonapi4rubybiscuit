RSpec.shared_context "destroyable jsonapi controller" do
  let(:role) {} unless method_defined?(:role)

  let(:do_before_request) {}
  let(:existing_resources_before_request) {}
  let(:resource_id) {}
  let(:params) { {id: resource_id} }

  before(:each) do
    do_before_request
    existing_resources_before_request
    request.headers["X-USER-ROLE"] = role
    delete :destroy, params: params
  end
end
