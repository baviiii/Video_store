FactoryBot.define do
  factory :user_rating do
    movie_id { 1 }
    rating { 1 }
    user_id { 1 }
  end
end
