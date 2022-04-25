class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.date :release_date, null: false
      t.string :runtime
      t.string :genre
      t.string :parental_rating
      t.text :plot

      t.timestamps
    end
  end
end
