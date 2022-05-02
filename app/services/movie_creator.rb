class MovieCreator < ApplicationService
  def initialize(params = {})
    @params = params
    @movie = nil
    @genres = []
  end

  def call
    ActiveRecord::Base.transaction do
      find_or_create_genres if params[:genres].present?
      create_movie
      add_genres_to_movie if genres.any?

      movie
    end
  end

  private

  attr_reader :params, :genres, :movie

  def search_genre(genre_name)
    Genre.where('lower(name) = ?', genre_name.downcase)
  end

  def find_or_create_genres
    params[:genres].split(', ').each do |genre_name|
      old_genres = search_genre(genre_name)

      if old_genres.any?
        @genres << old_genres.first
        next
      end

      @genres << Genre.create!(name: genre_name)
    end
  end

  def parental_rating
    return :undefined if params[:parental_rating].blank?

    case params[:parental_rating].downcase
    when 'g', 'general'
      :general
    when 'pg', 'parental guidance'
      :parental_guidance
    when 'pg-13', 'pg_13', 'pg 13', 'pg13'
      :parental_guidance_13
    when 'r', 'restricted'
      :restricted
    when 'nc-17', 'nc_17', 'nc 17', 'nc17'
      :adults_only
    else
      params[:parental_rating]
    end
  end

  def create_movie
    @movie = Movie.create!(
      title: params[:title],
      release_date: params[:release_date],
      runtime: params[:runtime],
      parental_rating: parental_rating,
      plot: params[:plot]
    )
  end

  def add_genres_to_movie
    movie.genres << genres
  end
end
