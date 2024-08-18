FactoryBot.define do
  factory :user do
              sequence :email do |n|
                "person#{n}@example.com"
              end
              password { '*Azhwaagkb12142521' }
    active { false }
    address_line_1 { "MyString" }
    address_line_2 { "MyString" }
    admin { false }
   
admin_
role { "super_user" }
    first_name { "MyString" }
   
gender { "male" }
    last_name { "MyString" }
    postcode { 1 }
    state { "MyString" }
    suburb { "MyString" }
  end
end
