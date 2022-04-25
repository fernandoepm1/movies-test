Rails.application.routes.draw do
  mount Movies::API => '/'
  mount Ratings::API => '/'
end
