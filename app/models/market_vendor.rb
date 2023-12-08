class MarketVendor < ApplicationRecord
  validates_presence_of :vendor_id, :market_id
  belongs_to :market
  belongs_to :vendor
end