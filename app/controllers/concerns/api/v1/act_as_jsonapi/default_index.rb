module API
  module V1
    module ActAsJSONAPI
      module DefaultIndex
        # This module defines the default index method
        # It applies filters and pagination

        def index
          authorize act_as_jsonapi_model, policy_class: act_as_jsonapi_policy_class
          act_as_jsonapi_validate_request_filters_param!
          set_default_order!

          resource = act_as_jsonapi_scope.all
          resource = act_as_jsonapi_query_filter(resource)
          resource = jsonapi_filter(resource, jsonapi_allowed_filters).result
          resource = jsonapi_paginate(resource)
          render jsonapi: resource
        end

        protected def set_default_order!
          params[:sort] = params.fetch(:sort, "id")
        end
      end
    end
  end
end
