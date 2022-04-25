require 'rails_helper'

RSpec.describe Movie, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { is_expected.to have_many :ratings }
end
