module API
  module V1
    class BookPolicy < API::V1::ApplicationPolicy
      def index?
        %w[admin guest].include? user.role
      end

      def show?
        %w[admin guest].include? user.role
      end

      def create?
        %w[admin].include?(user.role)
      end

      def update?
        %w[admin guest].include?(user.role)
      end

      def destroy?
        %w[admin].include? user.role
      end

      class Scope < Scope
        def resolve
          return scope if %w[admin].include?(user.role)
          return scope.public_books if %w[guest].include?(user.role)
        end
      end

      class AllowedFilters < AllowedFilters
        def resolve
          return %w[all_filters_allowed] if %w[admin].include?(user.role)

          %w[serializer_attributes]
        end
      end

      class Serializer < Serializer
        def resolve
          return API::V1::Admin::BookSerializer if %w[admin].include?(user.role)
          return API::V1::Guest::BookSerializer if %w[guest].include?(user.role)
        end
      end

      class CreateCommand < CreateCommand
        def resolve
          return API::V1::Admin::DefaultCreateCommand if %w[admin].include?(user.role)
        end
      end

      class UpdateCommand < UpdateCommand
        def resolve
          return API::V1::Admin::DefaultUpdateCommand if %w[admin].include?(user.role)
          return API::V1::Guest::Books::UpdateCommand if %w[guest].include?(user.role)
        end
      end
    end
  end
end
