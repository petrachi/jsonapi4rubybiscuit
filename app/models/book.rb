class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author

  scope :public_books, ->{ where(price: ..1100) }
end
