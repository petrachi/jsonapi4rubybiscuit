module API
  module V1
    module Admin
      class BookForm < Rectify::Form
        mimic :book

        attribute :name, String
        attribute :price, Integer

        belongs_to :author
        belongs_to :publisher

        validates :name, presence: true
        validates :price, presence: true, numericality: {greater_than: 0}
      end
    end
  end
end
