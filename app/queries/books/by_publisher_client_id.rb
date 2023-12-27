module Books
  class ByPublisherClientId < Rectify::Query
    attr_accessor :client_id

    def initialize client_id:
      self.client_id = client_id
    end

    def query
      Book.includes(:publisher).where(publisher: {client_id:})
    end
  end
end
