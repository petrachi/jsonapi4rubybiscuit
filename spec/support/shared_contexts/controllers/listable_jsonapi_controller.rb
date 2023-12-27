RSpec.shared_context "listable jsonapi controller" do
  let(:role) {} unless method_defined?(:role)

  let(:do_before_request) {}
  let(:existing_resources_before_request) {}
  let(:params) { {} }

  before(:each) do
    do_before_request
    existing_resources_before_request
    request.headers["X-USER-ROLE"] = role
    get :index, params: params
  end
end
