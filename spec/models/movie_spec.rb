require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:genres) }
    it { should have_many(:ratings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:release_date) }
    it { should validate_presence_of(:runtime) }
    it { should validate_numericality_of(:runtime).only_integer.is_greater_than(0) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:parental_rating).with_values(
        %i[undefined general parental_guidance
           parental_guidance_13 restricted adults_only]
      )
    end
  end
end
