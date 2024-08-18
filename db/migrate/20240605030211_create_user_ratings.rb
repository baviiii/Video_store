class CreateUserRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_ratings do |t|
      t.userstamps
      t.datetime :deleted_at
      t.integer :movie_id
      t.integer :rating
      t.integer :user_id

      t.timestamps
    end
    add_index :user_ratings, :movie_id
    add_index :user_ratings, :user_id
  end
end
