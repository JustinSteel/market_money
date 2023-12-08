class Vendor < ApplicationRecord
  validates_presence_of :name, :description, :contact_name, :contact_phone, credit_accepted: :boolean
  
  has_many :market_vendors
  has_many :markets, through: :market_vendors
end