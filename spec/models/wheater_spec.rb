# frozen_string_literal: trues

RSpec.describe Wheater, type: :model do
  it { should have_db_column(:city).of_type(:string) }
  it { should have_db_column(:temp).of_type(:float) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:temp) }
end
