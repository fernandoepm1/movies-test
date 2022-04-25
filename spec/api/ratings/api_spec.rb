require 'rails_helper'

RSpec.describe Ratings::API do
  let!(:movie) { Movie.create(title: "teste", release_date: Date.today) }

  describe 'POST /api/v1/ratings' do
    it 'adds rating to movie' do
      post "/api/v1/ratings", :params => { :movie_id => movie.id, grade: 2 }
      expect(response).to have_http_status(:created)
      expect(movie.ratings.count).to eq(1)
    end
  end
end
