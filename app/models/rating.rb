class Rating < ApplicationRecord
  belongs_to :movie

  validates :movie_id, :grade, presence: true
  validates :grade, numericality: { only_integer: true,
                                    greater_than: 0,
                                    less_than: 6 }

  after_save :update_movie_rating

  def update_movie_rating
    movie.update_rating
  end
end
