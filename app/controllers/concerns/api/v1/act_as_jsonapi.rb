module API
  module V1
    module ActAsJSONAPI
      extend ActiveSupport::Concern

      included do
        # Include relevant modules from jsonapi.rb and pundit gems
        include JSONAPI::Deserialization
        include JSONAPI::Errors
        include JSONAPI::Fetching
        include JSONAPI::Filtering
        include JSONAPI::Pagination
        include Pundit::Authorization

        # Include our own modules
        include API::V1::ActAsJSONAPI::Authentication
        include API::V1::ActAsJSONAPI::Authorization
        include API::V1::ActAsJSONAPI::Errors
        include API::V1::ActAsJSONAPI::QueryFiltering

        # We use class level accessors to save act_as_jsonapi's configuration
        class_accessors = %i[
          act_as_jsonapi_model
          act_as_jsonapi_name
          act_as_jsonapi_policy_class
          act_as_jsonapi_policy_allowed_filters_class
          act_as_jsonapi_policy_create_command_class
          act_as_jsonapi_policy_scope_class
          act_as_jsonapi_policy_serializer_class
          act_as_jsonapi_policy_update_command_class
          act_as_jsonapi_query_filters
          act_as_jsonapi_serializer_meta
        ]

        class_attribute(*class_accessors)
        delegate(*class_accessors, to: :class)
      end

      module ClassMethods
        # We set the act_as_jsonapi's configuration based on the method params
        # And we include the corresponding modules for the requested default actions
        # def act_as_jsonapi(model:, serializer_meta:, use_default_action:)
        def act_as_jsonapi(model:, query_filters:, serializer_meta:, use_default_action:)
          self.act_as_jsonapi_model = model
          self.act_as_jsonapi_name = model.name

          self.act_as_jsonapi_policy_class = "API::V1::#{act_as_jsonapi_name}Policy".constantize
          self.act_as_jsonapi_policy_allowed_filters_class = act_as_jsonapi_policy_class.const_get("AllowedFilters")
          self.act_as_jsonapi_policy_create_command_class = act_as_jsonapi_policy_class.const_get("CreateCommand")
          self.act_as_jsonapi_policy_scope_class = act_as_jsonapi_policy_class.const_get("Scope")
          self.act_as_jsonapi_policy_serializer_class = act_as_jsonapi_policy_class.const_get("Serializer")
          self.act_as_jsonapi_policy_update_command_class = act_as_jsonapi_policy_class.const_get("UpdateCommand")

          self.act_as_jsonapi_query_filters = query_filters
          self.act_as_jsonapi_serializer_meta = serializer_meta

          use_default_action.each do |action_name|
            include "API::V1::ActAsJSONAPI::Default#{action_name.to_s.camelize}".constantize
          end
        end
      end

      # This method overrides the jsonapi.rb default method
      # It allows to specify the serializer we want to use
      # in our case, the serializer to use is determined in the policy::serializer class
      protected def jsonapi_serializer_class(*_)
        act_as_jsonapi_policy_serializer_class.new(current_user).resolve
      end

      # This method overrides the jsonapi.rb default method
      # It allows to send params from the controller to the serializer
      protected def jsonapi_serializer_params
        {
          params: params,
          user: current_user,
          controller: self,
        }
      end

      # This method overrides the jsonapi.rb default method
      # It allows to define the `meta` key in the serialized response
      protected def jsonapi_meta(_resources)
        meta = {info: nil, deprecation: nil}

        if Rails.env.development? || Rails.env.staging?
          if %w[index].include? action_name
            meta[:allowed_filters] = "Permitted filters/sort attributes : " \
              "#{jsonapi_allowed_filters.map { |filter_name| "`#{filter_name}`" }.to_sentence} " \
              "(this key is only shown in development or staging environment)"
          end
        end

        meta.merge(act_as_jsonapi_serializer_meta)
      end

      # This method overrides the jsonapi.rb default method
      # It allows to define the allowed filters the consumer can use
      # In our case, the allowed filters are determined in the policy::allowed_filters class
      protected def jsonapi_allowed_filters
        self.act_as_jsonapi_policy_filtering_allowed = true

        (act_as_jsonapi_policy_allowed_filters_class.new(current_user).resolve || []).inject([]) do |acc, filter_name|
          case filter_name
          when "all_filters_allowed"
            acc += act_as_jsonapi_extract_filters + act_as_jsonapi_extract_sort
          when "serializer_attributes"
            acc += (jsonapi_serializer_class.attributes_to_serialize.keys.map(&:to_s) + ["id"])
          else
            acc << filter_name
          end
          acc
        end
      end

      # This method allows us to check if the filters params of the request is valid for index action
      protected def act_as_jsonapi_validate_request_filters_param!
        not_allowed_filters = act_as_jsonapi_extract_filters - jsonapi_allowed_filters

        if not_allowed_filters.present?
          raise API::V1::ActAsJSONAPI::Errors::BadRequestError, "filters `#{not_allowed_filters}' doesn't exist"
        end
      end

      # This method allow us to extract column names for the filters params from the request
      protected def act_as_jsonapi_extract_filters
        (params[:filter] || {}).keys.inject([]) do |acc, filter_name|
          attributes, = JSONAPI::Filtering.extract_attributes_and_predicates(filter_name)
          acc + attributes
        end
      end

      # This method allow us to extract column names for the sort params from the request
      protected def act_as_jsonapi_extract_sort
        params[:sort].to_s.split(",").map do |sort_name|
          sort_name.gsub(/^-(.*)$/, "\\1")
        end
      end

      # This method allows us to restrict the scope of the request based on the user's authorizations
      # The scope to use is determined in the policy::scope class
      # If no scope is defined in the policy, we return a null scope
      protected def act_as_jsonapi_scope
        scope = policy_scope(
          act_as_jsonapi_model_with_includes,
          policy_scope_class: act_as_jsonapi_policy_scope_class
        )
        scope || act_as_jsonapi_model.none
      end

      # This method allows us to include all the consumer's requested relationships in the active record query
      # This is done to avoid N+1 queries
      protected def act_as_jsonapi_model_with_includes
        if params[:include].present?
          act_as_jsonapi_model.includes(act_as_jsonapi_includes_from_params(params[:include]))
        else
          act_as_jsonapi_model
        end
      end

      # This method converts the `include` query param into a format we can use in active record `includes`
      # Ex: "versions,networks.stations" becomes something like [:versions, {networks: :stations}]
      protected def act_as_jsonapi_includes_from_params(includes_query_string)
        return unless includes_query_string

        includes_query_string.split(",").map do |inclusion_query|
          root_inclusion, nested_inclusions = inclusion_query.split(".", 2)
          if nested_inclusions
            {root_inclusion => act_as_jsonapi_includes_from_params(nested_inclusions)}
          else
            root_inclusion
          end
        end
      end

      # This method allows us to retrieve the command class to use for creation
      # The command to use is determined in the policy::create_command class
      protected def act_as_jsonapi_create_command_class
        self.act_as_jsonapi_policy_create = true
        act_as_jsonapi_policy_create_command_class.new(current_user).resolve
      end

      # This method allows us to retrieve the command class to use for update
      # The command to use is determined in the policy::update_command class
      protected def act_as_jsonapi_update_command_class
        self.act_as_jsonapi_policy_update = true
        act_as_jsonapi_policy_update_command_class.new(current_user).resolve
      end

      # This method allows us to check if the body of the request is valid for create and update actions
      # It checks that the `type` body param is correct
      protected def act_as_jsonapi_validate_request_type_param!
        if params[:data].try(:[], :type).blank?
          raise API::V1::ActAsJSONAPI::Errors::BadRequestError,
            "The resource object MUST contain at least a type member"
        end

        if params[:data][:type] != act_as_jsonapi_model.name.underscore
          raise API::V1::ActAsJSONAPI::Errors::ConflictError,
            "The resource object’s type does not match the server’s endpoint"
        end
      end

      # This method allows us to check if the body of the request is valid for update action
      # It checks that the `id` body param is correct
      protected def act_as_jsonapi_validate_request_id_param!
        if params[:data].try(:[], :id).blank?
          raise API::V1::ActAsJSONAPI::Errors::BadRequestError,
            "The resource object MUST contain at least an id member"
        end

        if params[:data][:id].to_s != params[:id].to_s
          raise API::V1::ActAsJSONAPI::Errors::ConflictError,
            "The resource object’s id does not match the server’s endpoint"
        end
      end
    end
  end
end
