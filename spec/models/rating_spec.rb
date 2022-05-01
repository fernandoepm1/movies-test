require 'rails_helper'

RSpec.describe Rating, type: :model do
  context 'associations' do
    it { should belong_to :movie }
  end

  context 'validations' do
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:grade) }
    it do
      should validate_numericality_of(:grade).only_integer
                                             .is_greater_than(0)
                                             .is_less_than(6)
    end
  end

  describe '#update_movie_rating' do
    subject(:movie) { create(:movie) }

    context 'when rating is created' do
      it 'should update movie rating' do
        create(:rating, movie: movie, grade: 5)

        expect(movie.reload.rating).to equal(5.0)
      end
    end

    context 'when rating is updated' do
      let(:rating) { create(:rating, movie: movie, grade: 5) }

      it 'should update movie rating' do
        rating.grade = 3
        rating.save

        expect(movie.reload.rating).to equal(3.0)
      end
    end
  end
end
