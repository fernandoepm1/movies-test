# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    release_date { Faker::Date.between(from: 50.years.ago, to: Date.today) }
    runtime { (50..180).to_a.sample }
    parental_rating { Movie.parental_ratings.keys.sample }
    plot { Faker::Lorem.paragraph }

    trait :with_genre do
      after(:build) do |movie|
        movie.genres << FactoryBot.build(:genre)
      end
    end
  end
end
