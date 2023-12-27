module API
  module V1
    class APIController < ActionController::API
      include API::V1::ActAsJSONAPI
    end
  end
end
