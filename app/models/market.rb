class Market < ApplicationRecord
  validates_presence_of :name
  has_many :market_vendors
  has_many :vendors, through: :market_vendors
end
