FactoryGirl.define do
  factory :post do
    user
    title { FFaker::Lorem.words(5) }
    body { FFaker::Lorem.words(20) }
  end
end
