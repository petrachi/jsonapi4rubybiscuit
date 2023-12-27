module API
  module V1
    module Guest
      class BookSerializer < ApplicationSerializer
        set_type :book

        attributes :name, :price

        belongs_to :author

        link :self do |object, params|
          params[:controller].api_v1_book_url(object)
        end
      end
    end
  end
end
