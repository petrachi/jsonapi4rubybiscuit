module API
  module V1
    class AuthorsController < APIController
      act_as_jsonapi model: ::Author,
        serializer_meta: {},
        query_filters: {},
        use_default_action: %i[index show create update destroy]
    end
  end
end
