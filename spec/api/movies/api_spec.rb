require 'rails_helper'

RSpec.describe Movies::API do
  let!(:movie) { Movie.create(title: "teste", release_date: Date.today) }
  let!(:movie2) { Movie.create(title: "teste2", release_date: Date.tomorrow) }

  describe 'GET /api/v1/movies' do
    it 'returns all movies' do
      get "/api/v1/movies/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("teste")
      expect(response.body).to include("teste2")
    end
  end

  describe 'GET /api/v1/movies/search' do
    it 'returns searched movie' do
      get "/api/v1/movies/search?title=2"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("teste2")
    end
  end

  describe 'GET /api/v1/movies/:id' do
    it 'returns movie using id' do
      get "/api/v1/movies/#{movie2.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("teste2")
    end
  end

  describe 'POST /api/v1/movies' do
    it 'returns movie using id' do
      post "/api/v1/movies", :params => { :title => "Any Name", release_date: Date.yesterday }
      expect(response).to have_http_status(:created)
      expect(Movie.count).to eq(3)
    end
  end

  describe 'DELETE /api/v1/movies' do
    it 'remove movie' do
      delete "/api/v1/movies/#{movie2.id}"
      expect(response).to have_http_status(:ok)
      expect(Movie.count).to eq(1)
    end
  end
end
