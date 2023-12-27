module API
  module V1
    module ActAsJSONAPI
      module Errors
        # This module handles errors
        # It's role is to define standard errors format, and to render them when needed
        # Note that some error cases are handled directly by the jsonapi.rb gem

        extend ActiveSupport::Concern

        class BadRequestError < StandardError; end
        class ConflictError < StandardError; end
        class InclusionError < StandardError; end

        included do
          rescue_from ArgumentError, with: :render_argument_error
          rescue_from ActionController::ParameterMissing, with: :render_bad_request
          rescue_from ActiveRecord::AssociationNotFoundError, with: :render_bad_request
          rescue_from JSONAPI::Serializer::UnsupportedIncludeError, with: :render_bad_request
          rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
          rescue_from API::V1::ActAsJSONAPI::Errors::ConflictError, with: :render_conflict
          rescue_from API::V1::ActAsJSONAPI::Errors::BadRequestError, with: :render_bad_request
          rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
        end

        # This method allows to rescue the 'parse params error'
        # We can't use the classic `rescue_from` for this error, as the execution does not go as far
        # This workaround was found here : https://github.com/rails/rails/issues/34244#issuecomment-433365579
        def process_action(*args)
          super
        rescue ActionDispatch::Http::Parameters::ParseError => error
          render_bad_request(error)
        end

        # This method allows to handle a special case of argument error
        # When an api consumer try to include relationship not defined in the serializer
        protected def render_argument_error(exception)
          if exception.message.include?("is not specified as a relationship")
            render_bad_request(exception)
          else
            render_jsonapi_internal_server_error(exception)
          end
        end

        protected def render_conflict(exception)
          acts_as_jsonapi_error(status: :conflict, code: 409, exception: exception, include_message: true)
        end

        protected def render_bad_request(exception)
          acts_as_jsonapi_error(status: :bad_request, code: 400, exception: exception, include_message: true)
        end

        protected def render_unprocessable_entity(exception)
          render jsonapi_errors: exception.record.errors, status: :unprocessable_entity
        end

        protected def render_unauthorized
          acts_as_jsonapi_error(status: :unauthorized, code: 401)
        end

        protected def render_forbidden
          acts_as_jsonapi_error(status: :forbidden, code: 403)
        end

        protected def render_jsonapi_internal_server_error(exception)
          acts_as_jsonapi_error(status: :internal_server_error, code: 500, exception: exception)
        end

        # This method defines the standard error format
        # In development and staging, it will add the stack trace to the serialized response
        protected def acts_as_jsonapi_error(status:, code:, exception: nil, include_message: false)
          error = {status: code.to_s, title: Rack::Utils::HTTP_STATUS_CODES[code]}

          if exception.present?
            raise exception if response_body

            #NewRelic::Agent.notice_error(exception, expected: status != :internal_server_error)
            @jsonapi_rescued_exception = exception

            if Rails.env.development? || Rails.env.staging? || Rails.env.test?
              error[:detail] = {
                message: exception.message,
                exception: exception.inspect,
                backtrace: exception.backtrace,
                info: "`exception` and `backtrace` keys are only shown in development or staging environment. " \
                    "`message` key will #{"not" unless include_message} be visible in production for this error type.",
              }
            elsif include_message
              error[:detail] = {message: exception.message}
            end
          end

          render jsonapi_errors: [error], status: status
        end

        def append_info_to_payload(payload)
          super
          if @jsonapi_rescued_exception
            payload[:exception] = [@jsonapi_rescued_exception.class, @jsonapi_rescued_exception.message]
            payload[:exception_object] = @jsonapi_rescued_exception
          end
        end
      end
    end
  end
end
