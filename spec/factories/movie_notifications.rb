FactoryBot.define do
  factory :movie_notification do
    active { false }
    canceled_on { "2024-06-05 12:31:32" }
    movie_copy_id { 1 }
    notified_on { "2024-06-05 12:31:32" }
    requested_on { "2024-06-05 12:31:32" }
    user_id { 1 }
  end
end
