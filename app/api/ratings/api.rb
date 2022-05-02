# frozen_string_literal: true

module Ratings
  class API < Grape::API
    version 'v1', using: :path
    prefix 'api'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    include ExceptionHandler

    resource :ratings do
      desc 'Add a new rating to an existing movie.'
      params do
        requires :movie_id, type: String, desc: 'Movie ID.'
        requires :grade, type: Integer, desc: 'Movie grade.'
      end

      post do
        Rating.create!(
          movie_id: params[:movie_id],
          grade: params[:grade]
        )
      end
    end
  end
end
