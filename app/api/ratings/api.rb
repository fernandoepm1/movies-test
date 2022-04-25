module Ratings
  class API < Grape::API
    version 'v1', using: :path
    prefix "api"
    format :json

    resource :ratings do
      desc 'add ratings to a movie'
      params do
        requires :movie_id, type: String, desc: 'Movie id.'
        requires :grade, type: Integer, desc: 'Movie grade.'
      end

      post do
        Rating.create!({
          movie_id: params[:movie_id],
          grade: params[:grade]
        })
      end
    end
  end
end
