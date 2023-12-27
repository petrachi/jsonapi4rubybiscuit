module API
  module V1
    module Guest
      module Books
        class UpdateForm < Rectify::Form
          mimic :book

          attribute :name, String

          validates :name, presence: true
        end
      end
    end
  end
end
