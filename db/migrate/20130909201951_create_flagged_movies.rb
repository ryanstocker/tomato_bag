class CreateFlaggedMovies < ActiveRecord::Migration
  def change
    create_table :flagged_movies do |t|
      t.integer :user_id
      t.integer :rt_movie_id
      t.string :rt_imdb_id
      t.string :title
      t.string :poster_detailed_url
      t.string :poster_original_url
      t.string :state

      t.timestamps
    end
  end
end
