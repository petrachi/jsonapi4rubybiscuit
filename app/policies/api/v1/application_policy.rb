module API
  module V1
    class ApplicationPolicy
      attr_reader :user, :resource

      def initialize(user, resource)
        @user = user
        @resource = resource
      end

      class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user = user
          @scope = scope
        end
      end

      class AllowedFilters
        attr_reader :user

        def initialize(user)
          @user = user
        end
      end

      class Serializer
        attr_reader :user

        def initialize(user)
          @user = user
        end
      end

      class CreateCommand
        attr_reader :user

        def initialize(user)
          @user = user
        end
      end

      class UpdateCommand
        attr_reader :user

        def initialize(user)
          @user = user
        end
      end
    end
  end
end
