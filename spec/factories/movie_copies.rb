FactoryBot.define do
  factory :movie_copy do
    active { false }
    copies { 1 }
    movie_id { 1 }
    on_hand { 1 }
    order_id { 1 }
    rental_price_cents { 1 }
    rental_price_currency { "MyString" }
   
stock_type { "" }
  end
end
