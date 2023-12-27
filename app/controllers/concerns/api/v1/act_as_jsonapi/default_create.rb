module API
  module V1
    module ActAsJSONAPI
      module DefaultCreate
        # This module defines the default create method
        # By default, it uses the create command class retrieved through the policy
        # But it can also be used with a custom command class, to create "shortcut" create actions
        # Ex :
        #   "POST instant_commutes/from_blueprint"
        #   -> create(command_class: CreateFromBlueprintCommand)

        def create(command_class: act_as_jsonapi_create_command_class)
          authorize act_as_jsonapi_model, policy_class: act_as_jsonapi_policy_class

          act_as_jsonapi_validate_request_type_param!

          resource = act_as_jsonapi_scope.new
          command_class.call(jsonapi_deserialize(params), resource, current_user) do
            on(:invalid) do |errors|
              render jsonapi_errors: errors, status: :unprocessable_entity
            end

            on(:ok) do |created_resource|
              render jsonapi: created_resource
            end
          end
        end
      end
    end
  end
end
