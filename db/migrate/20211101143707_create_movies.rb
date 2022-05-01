class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.date :release_date, null: false
      t.integer :runtime, null: false
      t.integer :parental_rating
      t.text :plot

      t.timestamps
    end
  end
end
