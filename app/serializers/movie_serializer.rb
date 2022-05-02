class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :release_date, :genres, :runtime,
             :parental_rating, :plot, :rating

  def genres
    return 'N/A' if object.genres.empty?

    object.genres.pluck(:name).join(', ')
  end

  def runtime
    "#{object.runtime} min"
  end

  def parental_rating
    Movie.human_attribute_name(
      "parental_rating.#{object.parental_rating}"
    )
  end

  def plot
    object.plot || 'N/A'
  end
end
