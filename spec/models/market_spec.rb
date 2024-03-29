require 'rails_helper'

RSpec.describe Market, type: :model do
  it { should have_many(:market_vendors) }
  it { should have_many(:vendors).through(:market_vendors) }
end
