module API
  module V1
    module Admin
      class BookSerializer < ApplicationSerializer
        set_type :book

        trusted_serializer model: Book,
          include_all_attributes: true,
          include_all_associations: true

        link :self do |object, params|
          params[:controller].api_v1_book_url(object)
        end
      end
    end
  end
end
