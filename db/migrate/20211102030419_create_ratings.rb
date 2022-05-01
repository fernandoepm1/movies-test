class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :grade, null: false

      t.timestamps
    end
  end
end
