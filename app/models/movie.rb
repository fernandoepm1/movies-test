class Movie < ApplicationRecord
  has_many :ratings
  validates :title, :release_date, :runtime, presence: true
  validates :runtime, numericality: { only_integer: true,
                                      greater_than: 0 }

end
