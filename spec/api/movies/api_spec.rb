require 'rails_helper'

RSpec.describe Movies::API do
  describe 'GET /api/v1/movies' do
    let!(:movies) { create_list(:movie, 7) }

    before(:each) do
      get '/api/v1/movies'
    end

    it 'should have http status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'should paginate the response with 5 per page' do
      expect(JSON.parse(response.body).size).to eq(5)
    end

    it 'should return the first 5 movies' do
      movies.first(5).each do |movie|
        expect(response.body).to include(movie.title)
      end
    end
  end

  describe 'GET /api/v1/movies/search' do
    let!(:movie)  { create(:movie, title: 'Titanic 2') }
    let!(:movie2) { create(:movie, title: 'Avatar 2') }
    let!(:movie3) { create(:movie, title: 'Ex Machina') }

    before(:each) do
      get "/api/v1/movies/search?#{query_params}"
    end

    context 'when no movies match the search' do
      let(:query_params) { 'title=Thunder' }

      it 'should have http status 500' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'should return an error message' do
        expect(response.body).to include('error')
        expect(response.body).to include('No movies found')
      end
    end

    context 'when movies match the search' do
      let(:query_params) { 'title=2' }

      it 'should have http status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return both movies matching the search' do
        expect(response.body).to include('Titanic 2')
        expect(response.body).to include('Avatar 2')
      end
    end
  end

  describe 'GET /api/v1/movies/:id' do
    before(:each) do
      get "/api/v1/movies/#{movie_id}"
    end

    context 'when no movie is found' do
      let(:movie_id) { 0 }

      it 'should have http status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'should return an error message' do
        expect(response.body).to include('error')
        expect(response.body).to include("Couldn't find Movie")
      end
    end

    context 'when the movie exists' do
      let!(:movie) { create(:movie, title: 'Fast and Furious 12') }
      let(:movie_id) { movie.id }

      it 'should have http status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return the movie with the given ID' do
        expect(response.body).to include(movie.title)
      end
    end
  end

  describe 'POST /api/v1/movies' do
    before(:each) do
      post '/api/v1/movies', params: params
    end

    context 'with invalid movie params' do
      context 'with a missing title' do
        let(:params) do
          { release_date: Date.today, runtime: 123 }
        end

        it 'should have http status 406' do
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'should not create a new movie in the database' do
          expect(Movie.count).to eq(0)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('title is missing')
        end
      end

      context 'with a missing release date' do
        let(:params) do
          { title: 'Dune', runtime: 123 }
        end

        it 'should have http status 406' do
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'should not create a new movie in the database' do
          expect(Movie.count).to eq(0)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('release_date is missing')
        end
      end

      context 'with a missing runtime' do
        let(:params) do
          { title: 'Tokyo Drift', release_date: '2006-08-11' }
        end

        it 'should have http status 406' do
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'should not create a new movie in the database' do
          expect(Movie.count).to eq(0)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('runtime is missing')
        end
      end
    end

    context 'with valid movie params' do
      let(:params) do
        {
          title: 'Kill Bill Vol. 3',
          release_date: Date.today.next_year(13),
          runtime: 123
        }
      end

      it 'should have http status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'should create a new movie in the database' do
        expect(Movie.count).to eq(1)
        expect(Movie.last.title).to eq(params[:title])
      end

      it 'should return a movie with the given params' do
        expect(response.body).to include(params[:title])
        expect(response.body).to include(params[:release_date].to_s)
        expect(response.body).to include(params[:runtime].to_s)
      end
    end
  end

  describe 'DELETE /api/v1/movies' do
    before(:each) do
      delete "/api/v1/movies/#{movie_id}"
    end

    context 'when no movie is found' do
      let(:movie_id) { 0 }

      it 'should have http status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'should return an error message' do
        expect(response.body).to include('error')
        expect(response.body).to include("Couldn't find Movie")
      end
    end

    context 'when the movie exists' do
      let!(:movie) { create(:movie, title: 'Tenacious D') }
      let(:movie_id) { movie.id }

      it 'should have http status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'should remove the movie from the database' do
        expect(Movie.count).to eq(0)
      end

      it 'should return the deleted movie' do
        expect(response.body).to include(movie.title)
      end
    end
  end
end
