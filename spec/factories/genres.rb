# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    name { %w[Action Adventure Comedy Horror Thriller].sample }
    description { Faker::Lorem.paragraph }
  end
end
