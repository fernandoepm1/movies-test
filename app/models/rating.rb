class Rating < ApplicationRecord
  belongs_to :movie

  validates_numericality_of :grade, :greater_than => 0, :less_than => 6
end
