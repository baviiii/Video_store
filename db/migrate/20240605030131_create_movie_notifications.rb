class CreateMovieNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_notifications do |t|
      t.userstamps
      t.datetime :deleted_at
      t.boolean :active
      t.datetime :canceled_on
      t.integer :movie_copy_id
      t.datetime :notified_on
      t.datetime :requested_on
      t.integer :user_id

      t.timestamps
    end
    add_index :movie_notifications, :movie_copy_id
    add_index :movie_notifications, :user_id
  end
end
