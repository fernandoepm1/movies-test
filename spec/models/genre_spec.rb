require 'rails_helper'

RSpec.describe Genre, type: :model do
  context 'associations' do
    it { should have_and_belong_to_many :movies }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
