require 'rails_helper'

RSpec.describe Movie, type: :model do
  context 'associations' do
    it { should have_and_belong_to_many(:genres) }
    it { should have_many(:ratings) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:release_date) }
    it { should validate_presence_of(:runtime) }
    it { should validate_numericality_of(:runtime).only_integer
                                                  .is_greater_than(0) }
  end

  it { should define_enum_for(:parental_rating).with(%i[g pg pg_13 r nc_17]) }
end
