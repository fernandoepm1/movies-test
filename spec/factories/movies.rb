FactoryBot.define do
  factory :movie do
    title { "MyString" }
    release_date { "2021-11-01" }
    runtime { "MyString" }
    genre { "MyString" }
    parental_rating { "MyString" }
    plot { "MyText" }
  end
end
