class Wheater < ApplicationRecord
  validates :city, :temp, presence: true
end
