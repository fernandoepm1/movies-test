require 'rails_helper'

RSpec.describe RatingSerializer, type: :serializer do
  subject(:serialized_object) { serializer.serializable_hash }

  let(:serializer) { described_class.new(rating) }

  context 'when movie has no genres' do
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, movie: movie) }

    it 'should have serialized the object correctly' do
      expect(serialized_object).to eq(
        {
          id: rating.id,
          grade: rating.grade,
          movie: {
            id: movie.id,
            title: movie.title,
            release_date: movie.release_date,
            genres: 'N/A',
            runtime: "#{movie.runtime} min",
            parental_rating: parental_rating,
            plot: movie.plot,
            rating: movie.rating
          }
        }
      )
    end
  end

  context 'when movie has genres' do
    let(:movie) { create(:movie, :with_genre) }
    let(:rating) { create(:rating, movie: movie) }

    it 'should have serialized the object correctly' do
      expect(serialized_object).to eq(
        {
          id: rating.id,
          grade: rating.grade,
          movie: {
            id: movie.id,
            title: movie.title,
            release_date: movie.release_date,
            genres: movie.genres.pluck(:name).join(', '),
            runtime: "#{movie.runtime} min",
            parental_rating: parental_rating,
            plot: movie.plot,
            rating: movie.rating
          }
        }
      )
    end
  end

  def parental_rating
    Movie.human_attribute_name(
      "parental_rating.#{movie.parental_rating}"
    )
  end
end
