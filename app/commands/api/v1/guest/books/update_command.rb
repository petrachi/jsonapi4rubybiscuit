module API
  module V1
    module Guest
      module Books
        class UpdateCommand < Rectify::Command
          attr_accessor :form, :resource

          def initialize(params, resource, _current_user)
            self.resource = resource
            self.form = API::V1::Guest::Books::UpdateForm.from_model(resource)
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
end
