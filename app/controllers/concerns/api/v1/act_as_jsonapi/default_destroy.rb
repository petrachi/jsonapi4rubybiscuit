module API
  module V1
    module ActAsJSONAPI
      module DefaultDestroy
        # This module defines the default destroy method

        def destroy
          resource = act_as_jsonapi_scope.find_by!(id: params["id"])
          authorize resource, policy_class: act_as_jsonapi_policy_class

          if resource.destroy
            head :no_content
          else
            render jsonapi_errors: resource.errors, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
