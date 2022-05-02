require 'rails_helper'

RSpec.describe MovieCreator, type: :service do
  describe '#call' do
    subject(:call_service) { described_class.call(params) }

    context 'when genres param is not present' do
      context 'with a valid parental_rating param' do
        let(:params) do
          {
            title: 'Terminator 7',
            release_date: '2029-12-12',
            runtime: 123,
            parental_rating: 'general'
          }
        end

        it 'should not create a new genre' do
          expect { call_service }.to change { Genre.count }.by(0)
        end

        it 'should create a new movie' do
          expect { call_service }.to change { Movie.count }.by(1)
        end

        it 'should have created the movie with the given params' do
          call_service

          expect(Movie.last.title).to eq(params[:title])
          expect(Movie.last.release_date).to eq(params[:release_date].to_date)
          expect(Movie.last.runtime).to eq(params[:runtime])
          expect(Movie.last.parental_rating).to eq(params[:parental_rating])
        end
      end

      context 'with an invalid parental_rating param' do
        let(:params) do
          {
            title: 'Robocop 2',
            release_date: '2023-04-13',
            runtime: 107,
            parental_rating: 'invalid'
          }
        end

        it 'should raise an error' do
          expect { call_service }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when genres param is present' do
      context 'when genre already exists in database' do
        let!(:genre) { create(:genre, name: 'Fantasy') }
        let(:params) do
          {
            title: 'Super Hero Movie',
            release_date: '2021-12-12',
            runtime: 92,
            parental_rating: 'restricted',
            genres: 'Fantasy'
          }
        end

        it 'should not create a new genre' do
          expect { call_service }.to change { Genre.count }.by(0)
        end

        it 'should create a new movie' do
          expect { call_service }.to change { Movie.count }.by(1)
        end

        it 'should create the movie with given params' do
          call_service

          expect(Movie.last.title).to eq(params[:title])
          expect(Movie.last.release_date).to eq(params[:release_date].to_date)
          expect(Movie.last.runtime).to eq(params[:runtime])
        end

        it 'should add the genre to the movie' do
          call_service

          expect(Movie.last.genres).to eq([genre])
        end
      end

      context 'when genre does not exist in database' do
        let(:params) do
          {
            title: 'Blue Lagoon 2',
            release_date: '2045-12-12',
            runtime: 89,
            parental_rating: 'nc17',
            genres: 'Romance'
          }
        end

        it 'should create a new genre' do
          expect { call_service }.to change { Genre.count }.by(1)
        end

        it 'should create the genre with the given param' do
          call_service

          expect(Genre.last.name).to eq(params[:genres])
        end

        it 'should create a new movie' do
          expect { call_service }.to change { Movie.count }.by(1)
        end

        it 'should create the movie with the given params' do
          call_service

          expect(Movie.last.title).to eq(params[:title])
          expect(Movie.last.release_date).to eq(params[:release_date].to_date)
          expect(Movie.last.runtime).to eq(params[:runtime])
        end

        it 'should add the genre to the movie' do
          call_service

          expect(Movie.last.genres).to eq([Genre.last])
        end
      end
    end
  end
end
