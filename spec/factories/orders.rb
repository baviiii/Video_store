FactoryBot.define do
  factory :order do
    order_date { "2024-06-05" }
    order_titles { "MyString" }
    return_due { "2024-06-05" }
    returned { false }
    returned_on { "2024-06-05 12:31:42" }
   
status { "pending" }
    user_id { 1 }
  end
end
