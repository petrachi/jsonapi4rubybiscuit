module API
  module V1
    class PublishersController < APIController
      act_as_jsonapi model: ::Publisher,
        serializer_meta: {},
        query_filters: {},
        use_default_action: %i[index show create update destroy]
    end
  end
end
