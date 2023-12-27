module API
  module V1
    module Guest
      class AuthorSerializer < ApplicationSerializer
        set_type :author

        attributes :name, :description

        has_many :books

        link :self do |object, params|
          params[:controller].api_v1_author_url(object)
        end
      end
    end
  end
end
