FactoryBot.define do
  factory :communication_record do
    body { "MyText" }
    communication_recordable_id { 1 }
    communication_recordable_type { "MyString" }
    from { "MyString" }
    received_at { "2024-06-05 12:30:28" }
    sent_at { "2024-06-05 12:30:28" }
    subject { "MyString" }
    to { "MyString" }
  end
end
