# frozen_string_literal: true

module Movies
  class API < Grape::API
    version 'v1', using: :path
    prefix 'api'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    include ExceptionHandler

    resource :movies do
      desc 'Returns a paginated list of movies.'
      paginate per_page: 5, max_per_page: 10
      get do
        paginate Movie.all
      end

      desc 'Searches movies by title.'
      params do
        optional :title, type: String, desc: 'Search term.'
      end

      paginate per_page: 5, max_per_page: 10
      get '/search' do
        movies = Movie.where("title ILIKE '%#{params[:title]}%'")

        if movies.any?
          paginate movies
        else
          error! 'No movies found for this search', :internal_server_error
        end
      end

      desc 'Shows information about a particular movie.'
      params do
        requires :id, type: String, desc: 'Movie ID.'
      end

      get '/:id' do
        Movie.find(params[:id])
      end

      desc 'Creates a movie.'
      params do
        requires :title, type: String, desc: 'Movie title.'
        requires :release_date, type: Date, desc: 'Movie release date.'
        requires :runtime, type: String, desc: 'Movie runtime.'
        optional :genres, type: String, desc: 'Movie genres.'
        optional :parental_rating, type: String, desc: 'Movie parental rating.'
        optional :plot, type: String, desc: 'Movie plot.'
      end

      post do
        MovieCreator.call(params)
      end

      desc 'Deletes a movie.'
      params do
        requires :id, type: String, desc: 'Movie ID.'
      end

      delete ':id' do
        Movie.find(params[:id]).destroy
      end
    end
  end
end
