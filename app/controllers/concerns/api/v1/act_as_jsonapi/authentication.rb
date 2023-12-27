module API
  module V1
    module ActAsJSONAPI
      module Authentication
        # This module handles authentication
        # It's role is to authenticate the user, or render an unauthorized response

        extend ActiveSupport::Concern

        included do
          before_action :authenticate
        end

        protected def authenticate
          authenticate_header || render_unauthorized
        end

        protected def authenticate_header
          if %w[admin guest].include? request.headers["X-USER-ROLE"]
            @current_user = OpenStruct.new(role: request.headers["X-USER-ROLE"])
          end
        end

        protected def current_user
          @current_user
        end
      end
    end
  end
end
