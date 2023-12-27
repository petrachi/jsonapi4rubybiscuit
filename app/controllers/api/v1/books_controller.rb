module API
  module V1
    class BooksController < APIController
      act_as_jsonapi model: ::Book,
        serializer_meta: {},
        query_filters: {"cheapests" => Books::Cheapests, "publisher" => Books::ByPublisherClientId},
        use_default_action: %i[index show create update destroy]
    end
  end
end
