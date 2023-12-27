module API
  module V1
    module ActAsJSONAPI
      module Authorization
        # This module handles authorization
        # It's role is to ensure that the different policies are called during the code execution

        extend ActiveSupport::Concern

        # class PolicyFilteringAllowedNotPerformedError < StandardError; end
        class PolicyFilteringAllowedNotPerformedError < Pundit::AuthorizationNotPerformedError; end
        class PolicyCreateNotPerformedError < Pundit::AuthorizationNotPerformedError; end
        class PolicyUpdateNotPerformedError < Pundit::AuthorizationNotPerformedError; end

        included do
          # rubocop:disable Rails/LexicallyScopedActionFilter
          after_action :verify_authorized
          after_action :verify_policy_create, only: %i[create]
          after_action :verify_policy_filtering_allowed, only: %i[index]
          after_action :verify_policy_scoped, only: %i[index show update delete]
          after_action :verify_policy_update, only: %i[update]
          # rubocop:enable Rails/LexicallyScopedActionFilter

          attr_accessor :act_as_jsonapi_policy_create,
            :act_as_jsonapi_policy_filtering_allowed,
            :act_as_jsonapi_policy_update
        end

        protected def policy_filtering_allowed?
          !!act_as_jsonapi_policy_filtering_allowed
        end

        protected def verify_policy_filtering_allowed
          unless policy_filtering_allowed?
            raise API::V1::ActAsJSONAPI::Authorization::PolicyFilteringAllowedNotPerformedError, self.class
          end
        end

        protected def policy_create?
          !!act_as_jsonapi_policy_create
        end

        protected def verify_policy_create
          raise API::V1::ActAsJSONAPI::Authorization::PolicyCreateNotPerformedError, self.class unless policy_create?
        end

        protected def policy_update?
          !!act_as_jsonapi_policy_update
        end

        protected def verify_policy_update
          raise API::V1::ActAsJSONAPI::Authorization::PolicyUpdateNotPerformedError, self.class unless policy_update?
        end
      end
    end
  end
end
