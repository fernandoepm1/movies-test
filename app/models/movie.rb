class Movie < ApplicationRecord
  has_many :ratings
  validates :title, :release_date, :runtime, presence: true
  validates :runtime, numericality: { only_integer: true,
                                      greater_than: 0 }

  enum parental_rating: %i[g pg pg_13 r nc_17]
end
