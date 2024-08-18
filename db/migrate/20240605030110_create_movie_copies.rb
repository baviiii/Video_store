class CreateMovieCopies < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_copies do |t|
      t.userstamps
      t.datetime :deleted_at
      t.boolean :active
      t.integer :copies
      t.integer :movie_id
      t.integer :on_hand
      t.integer :order_id
      t.integer :rental_price_cents
      t.string :rental_price_currency
      t.string :stock_type

      t.timestamps
    end
    add_index :movie_copies, :movie_id
    add_index :movie_copies, :order_id
  end
end
