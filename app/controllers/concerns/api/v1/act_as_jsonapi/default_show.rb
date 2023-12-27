module API
  module V1
    module ActAsJSONAPI
      module DefaultShow
        # This module defines the default show method

        def show
          resource = act_as_jsonapi_scope.find_by!(id: params[:id])
          authorize resource, policy_class: act_as_jsonapi_policy_class

          render jsonapi: resource
        end
      end
    end
  end
end
