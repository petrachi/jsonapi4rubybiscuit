FactoryBot.define do
  factory :book do
    name { "toto" }
    price { 12 }

    author { create :author }
    publisher { create :publisher }
  end
end
