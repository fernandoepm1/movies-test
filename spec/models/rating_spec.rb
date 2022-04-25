require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { is_expected.to belong_to :movie }

  it 'grade cannnot be less than 0' do
    rating = FactoryBot.build(:rating, grade: -1)
    expect(rating.valid?).to eq false
  end

  it 'grade cannnot be more than 5' do
    rating = FactoryBot.build(:rating, grade: 6)
    expect(rating.valid?).to eq false
  end
end
