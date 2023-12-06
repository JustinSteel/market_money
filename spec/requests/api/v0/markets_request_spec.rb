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

  it "should return a list of all the vendors for a market" do
    id = create(:market).id
    create_list(:vendor, 5, markets: [Market.find(id)])

    get "/api/v0/markets/#{id}"

    expect(response).to have_http_status(200)
    market = JSON.parse(response.body, symbolize_names: true)
    solo_market = market[:data]
    vendors = solo_market[:relationships][:vendors][:data]
    
    expect(vendors.count).to eq(5)

    expect(vendors).to be_an(Array)

    expect(vendors[0]).to have_key(:id)
    expect(vendors[0][:id]).to be_a(String)

    expect(vendors[0]).to have_key(:type)
    expect(vendors[0][:type]).to be_a(String)
  end

  
end