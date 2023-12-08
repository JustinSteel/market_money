require "rails_helper"

describe "Markets API", type: :request do
  it "gets a list of Markets" do
    markets = create_list(:market, 20)

    get '/api/v0/markets'

    expect(response).to have_http_status(200)
    market = JSON.parse(response.body, symbolize_names: true)
    solo_market = market[:data][0]
    expect(market[:data].count).to eq(20)

    expect(solo_market[:attributes][:name]).to eq(markets[0].name)
    expect(market[:data][9][:attributes][:name]).to eq(markets[9].name)
    expect(market[:data][19][:attributes][:name]).to eq(markets[19].name)
    
    expect(market[:data]).to be_an(Array)
    expect(market).to have_key(:data)
    expect(solo_market[:id]).to be_a(String)
    expect(solo_market[:id]).to eq(markets.first.id.to_s)

    expect(solo_market).to have_key(:type)
    expect(solo_market[:type]).to be_a(String)

    expect(solo_market).to have_key(:attributes)
    expect(solo_market[:attributes]).to be_a(Hash)

    expect(solo_market[:attributes]).to have_key(:name)
    expect(solo_market[:attributes][:name]).to be_a(String)
    
    expect(solo_market[:attributes]).to have_key(:street)
    expect(solo_market[:attributes][:street]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:city)
    expect(solo_market[:attributes][:city]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:county)
    expect(solo_market[:attributes][:county]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:state)
    expect(solo_market[:attributes][:state]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:zip)
    expect(solo_market[:attributes][:zip]).to be_a(String)
    
    expect(solo_market[:attributes]).to have_key(:lat)
    expect(solo_market[:attributes][:lat]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:lon)
    expect(solo_market[:attributes][:lon]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:vendor_count)
    expect(solo_market[:attributes][:vendor_count]).to be_a(Integer)
  end

  it "can get one Market by its id" do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    expect(response).to have_http_status(200)
    market = JSON.parse(response.body, symbolize_names: true)
    solo_market = market[:data]

    expect(solo_market).to be_a(Hash)

    expect(solo_market).to have_key(:id) 
    expect(solo_market[:id]).to be_a(String)

    expect(solo_market[:attributes]).to be_a(Hash)

    expect(solo_market[:attributes]).to have_key(:name)
    expect(solo_market[:attributes][:name]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:street)
    expect(solo_market[:attributes][:street]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:city)
    expect(solo_market[:attributes][:city]).to be_a(String)
    
    expect(solo_market[:attributes]).to have_key(:county)
    expect(solo_market[:attributes][:county]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:state)
    expect(solo_market[:attributes][:state]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:zip)
    expect(solo_market[:attributes][:zip]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:lat)
    expect(solo_market[:attributes][:lat]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:lon)
    expect(solo_market[:attributes][:lon]).to be_a(String)

    expect(solo_market[:attributes]).to have_key(:vendor_count)
    expect(solo_market[:attributes][:vendor_count]).to be_a(Integer)
    expect(solo_market[:attributes][:vendor_count]).to eq(0) 
  end

  it "returns a 404 if the market is not found" do
    get "/api/v0/markets/112255336"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=112255336")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end

  it "should return a list of all the vendors for a market" do
    market = create(:market)
    # require 'pry'; binding.pry
    market.vendors << create_list(:vendor, 5)

    get "/api/v0/markets/#{market.id}/vendors"

    expect(response).to have_http_status(200)
    vendor_data = JSON.parse(response.body, symbolize_names: true)
    vendors = vendor_data[:data].first[:attributes]

    expect(vendor_data).to have_key(:data)
    expect(vendor_data[:data]).to be_an(Array)
    expect(vendors).to have_key(:name)
    expect(vendors).to have_key(:description)
    expect(vendors).to have_key(:contact_name)
    expect(vendors).to have_key(:contact_phone)
    expect(vendors).to have_key(:credit_accepted)
    expect(vendors.keys.length).to eq(5)

    expect(vendor_data[:data][0][:type]).to eq('vendor')
    expect(vendor_data[:data].length).to eq(5)
    # require 'pry'; binding.pry

    expect(vendors[:name]).to eq(market.vendors.first.name)
    expect(vendors[:description]).to eq("#{market.vendors.first.description}")
    expect(vendors[:contact_name]).to eq("#{market.vendors.first.contact_name}")
    expect(vendors[:contact_phone]).to eq("#{market.vendors.first.contact_phone}")
    expect(vendors[:credit_accepted]).to eq(market.vendors.first.credit_accepted)
  end

  it "should return a 404 if the market is not found" do
    get "/api/v0/markets/112255336445/vendors"

    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=112255336445")
    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:title)
  end
end