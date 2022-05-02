require 'rails_helper'

RSpec.describe Ratings::API do
  let!(:movie) { create(:movie, :with_genre) }

  describe 'POST /api/v1/ratings' do
    before(:each) do
      post '/api/v1/ratings', params: params
    end

    context 'with invalid rating params' do
      context 'when no movie_id is provided' do
        let(:params) do
          { grade: 2 }
        end

        it 'should have http status not acceptable' do
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('movie_id is missing')
        end

        it 'should not create a new rating' do
          expect(movie.ratings.count).to eq(0)
        end
      end

      context 'when no grade is provided' do
        let(:params) do
          { movie_id: movie.id }
        end

        it 'should have http status not acceptable' do
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('grade is missing')
        end

        it 'should not create a new rating' do
          expect(movie.ratings.count).to eq(0)
        end
      end

      context 'when an invalid movie_id is provided' do
        let(:params) do
          { movie_id: 0, grade: 5 }
        end

        it 'should have http status not acceptable' do
          expect(response).to have_http_status(:internal_server_error)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('Movie must exist')
        end

        it 'should not create a new rating' do
          expect(movie.ratings.count).to eq(0)
        end
      end

      context 'when an invalid grade is provided' do
        let(:params) do
          { movie_id: movie.id, grade: -1 }
        end

        it 'should have http status not acceptable' do
          expect(response).to have_http_status(:internal_server_error)
        end

        it 'should return an error message' do
          expect(response.body).to include('error')
          expect(response.body).to include('Grade must be greater than 0')
        end

        it 'should not create a new rating' do
          expect(movie.ratings.count).to eq(0)
        end
      end
    end

    context 'with valid rating params' do
      let(:params) do
        { movie_id: movie.id, grade: 5 }
      end

      it 'should have http status created' do
        expect(response).to have_http_status(:created)
      end

      it 'should not return an error message' do
        expect(response.body).to_not include('error')
      end

      it 'should create a new rating for the movie' do
        expect(movie.ratings.count).to eq(1)
      end
    end
  end
end
