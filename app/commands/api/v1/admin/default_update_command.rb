module API
  module V1
    module Admin
      class DefaultUpdateCommand < Rectify::Command
        attr_accessor :form, :resource, :current_user

        def initialize(params, resource, current_user)
          self.resource = resource
          self.form = "API::V1::Admin::#{resource.class.name}Form".constantize.from_model(resource)
          self.current_user = current_user
          form.attributes = params
        end

        def call
          return broadcast(:invalid, form.errors) if form.invalid?

          resource.update!(form.attributes)
          broadcast(:ok, resource)
        end
      end
    end
  end
end
