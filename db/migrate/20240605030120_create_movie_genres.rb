class CreateMovieGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_genres do |t|
      t.userstamps
      t.datetime :deleted_at
      t.integer :movie_id
      t.integer :genre_id
      t.timestamps
    end
    add_index :movie_genres, :movie_id
    add_index :movie_genres, :genre_id
  end
end
