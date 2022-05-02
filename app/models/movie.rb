class Movie < ApplicationRecord
  has_and_belongs_to_many :genres, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :title, :release_date, :runtime, presence: true
  validates :runtime, numericality: { only_integer: true,
                                      greater_than: 0 }

  enum parental_rating: {
    undefined: 0,
    general: 1,
    parental_guidance: 2,
    parental_guidance_13: 3,
    restricted: 4,
    adults_only: 5
  }

  def update_rating
    update_column(:rating, ratings.average(:grade).round(1))
  end
end
