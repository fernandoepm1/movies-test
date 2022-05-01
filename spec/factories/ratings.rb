# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    movie
    grade { (1..5).to_a.sample }
  end
end
