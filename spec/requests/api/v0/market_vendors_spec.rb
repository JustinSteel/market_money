require "rails_helper"

RSpec.describe MarketVendor do
  describe "GET /market_vendors" do
    it "can create a market vendor" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
                              market_id: market.id,
                              vendor_id: vendor.id
                            })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: market.id, vendor_id: vendor.id)
      created_market_vendor = MarketVendor.last
      expect(response.status).to eq(201)
      expect(MarketVendor.count).to eq(1)
      expect(created_market_vendor.market_id).to eq(market.id)
      expect(created_market_vendor.vendor_id).to eq(vendor.id)
    end

    it "can't create a market vendor without a market id" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
                              market_id: market.id,
                              vendor_id: vendor.id
                            })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(vendor_id: vendor.id)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(MarketVendor.count).to eq(0)

      expect(data).to have_key(:message)
      expect(data[:message]).to eq("Validation failed: Market can't be blank, Vendor can't be blank")
    end

    it "can't create a market vendor with an invalid market id" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
                              market_id: market.id,
                              vendor_id: vendor.id
                              })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: 112223515, vendor_id: vendor.id)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(MarketVendor.count).to eq(0)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=112223515")
    end

    it "can delete a market vendor" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors/#{market_vendor.id}"
      expect(response.status).to eq(204)
      expect(MarketVendor.count).to eq(0)
    end

    it "can't delete a market vendor with an invalid id" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors/112223515"
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(MarketVendor.count).to eq(1)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to eq("Market Vendor with id 112223515 not found")
    end
  end
end