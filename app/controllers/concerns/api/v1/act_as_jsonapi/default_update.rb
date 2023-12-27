module API
  module V1
    module ActAsJSONAPI
      module DefaultUpdate
        # This module defines the default update method
        # By default, it uses the update command class retrieved through the policy
        # But it can also be used with a custom command class, to create "shortcut" update actions
        # Ex :
        #   "PATCH rides/claim"
        #   -> update(command_class: ClaimRideCommand)

        def update(command_class: act_as_jsonapi_update_command_class)
          resource = act_as_jsonapi_scope.find_by!(id: params["id"])
          authorize resource, policy_class: act_as_jsonapi_policy_class

          act_as_jsonapi_validate_request_type_param!
          act_as_jsonapi_validate_request_id_param!

          command_class.call(jsonapi_deserialize(params), resource, current_user) do
            on(:invalid) do |errors|
              render jsonapi_errors: errors, status: :unprocessable_entity
            end

            on(:ok) do |updated_resource|
              render jsonapi: updated_resource
            end
          end
        end
      end
    end
  end
end
