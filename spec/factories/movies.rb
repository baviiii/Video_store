FactoryBot.define do
  factory :movie do
    active { false }
   
content_rating { "" }
    cover { "MyString" }
    description { "MyText" }
    released_on { "2024-06-05" }
    remove_cover { false }
    title { "MyString" }
  end
end
