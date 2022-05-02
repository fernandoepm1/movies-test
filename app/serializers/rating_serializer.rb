class RatingSerializer < ActiveModel::Serializer
  attributes :id, :grade

  belongs_to :movie
end
