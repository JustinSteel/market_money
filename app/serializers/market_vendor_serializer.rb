class MarketVendorSerializer
include JSONAPI::Serializer
  attributes :id, :vendor_id, :market_id
  
  belongs_to :market
  belongs_to :vendor
end