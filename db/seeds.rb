# frozen_string_literal: true

genre_names = [
  'Action', 'Adventure', 'Animation', 'Comedy', 'Documentary',
  'Drama', 'Fantasy', 'Historical', 'Horror', 'Musical', 'Romance',
  'Science Fiction', 'Thriller', 'Western'
]

genre_names.each do |genre_name|
  FactoryBot.create(:genre, name: genre_name)
end

50.times do
  movie = FactoryBot.create(:movie)
  movie.genres << Genre.all.sample(rand(1..3))

  ratings_number = rand(3..10)
  ratings_number.times do
    FactoryBot.create(:rating, movie: movie)
  end
end
