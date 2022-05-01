class AddRatingToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :rating, :float, default: 0
  end
end
