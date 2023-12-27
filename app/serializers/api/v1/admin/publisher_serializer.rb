module API
  module V1
    module Admin
      class PublisherSerializer < ApplicationSerializer
        set_type :publisher

        trusted_serializer model: Publisher,
          include_all_attributes: true,
          include_all_associations: true

        link :self do |object, params|
          params[:controller].api_v1_publisher_url(object)
        end
      end
    end
  end
end
