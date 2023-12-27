module API
  module V1
    module ActAsJSONAPI
      module QueryFiltering
        # This module handles query filtering
        # Query filtering is our own filtering methods, defined through query objects

        # This method parses the `filter` query param and applies the corresponding queries
        protected def act_as_jsonapi_query_filter(resources)
          return resources unless params[:filter]

          resources = act_as_jsonapi_query_filters
            .slice(*act_as_jsonapi_query_filters_to_apply)
            .reduce(resources) do |scope, (filter, query)|
              scope.merge(
                query.new(**act_as_jsonapi_query_options(filter, query)).query
              )
            end

          block_given? ? yield(resources) : resources
        end

        # This method parses the `filter` query param to detect wich filter needs to be performed
        # It also checks if the filters are allowed
        protected def act_as_jsonapi_query_filters_to_apply
          params[:filter].keys & act_as_jsonapi_query_filters.keys & jsonapi_allowed_filters
        end

        # This method parses the `filter` query param to extract the parameters for a specific filter
        # It also checks the query object to see if all required parameters are present
        protected def act_as_jsonapi_query_options(filter, query)
          query_parameters = act_as_jsonapi_query_filter_params(query)

          if query_parameters[:parameters].empty?
            params
              .require(:filter)
              .permit(filter)
              .to_h
              .symbolize_keys
          else
            params
              .require(:filter)
              .require(filter)
              .permit(*query_parameters[:parameters])
              .tap do |filter_params|
                query_parameters[:required_parameters].each do |required_parameter|
                  filter_params.require(required_parameter)
                end
              end
              .to_h
              .symbolize_keys
          end
        end

        # This method extract required and optional parameters from the `initialize` method of a query object
        protected def act_as_jsonapi_query_filter_params(query)
          query_parameters = query.instance_method(:initialize).parameters
          required_parameters = query_parameters
            .select { |(type, _)| type == :keyreq }
            .map { |(_, parameter)| parameter }
          optional_parameters = query_parameters
            .select { |(type, _)| type == :key }
            .map { |(_, parameter)| parameter }

          {
            parameters: required_parameters + optional_parameters,
            required_parameters: required_parameters,
            optional_parameters: optional_parameters,
          }
        end
      end
    end
  end
end
