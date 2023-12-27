module API
  module V1
    module Admin
      class AuthorSerializer < ApplicationSerializer
        set_type :author

        trusted_serializer model: Author,
          include_all_attributes: true,
          include_all_associations: true

        link :self do |object, params|
          params[:controller].api_v1_author_url(object)
        end
      end
    end
  end
end
