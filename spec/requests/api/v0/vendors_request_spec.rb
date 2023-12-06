require "rails_helper"

RSpec.describe Vendor, type: :request do
  describe "GET /vendors" do
    it "returns one vendor" do
      id = create(:vendor).id

    get "/api/v0/vendors/#{id}"

    expect(response).to have_http_status(200)
    vendor = JSON.parse(response.body, symbolize_names: true)
    solo_vendor = vendor[:data]

    expect(vendor).to have_key(:data)
    expect(vendor[:data]).to be_an(Hash)

    expect(solo_vendor).to have_key(:id)
    expect(solo_vendor[:id]).to be_a(String)

    expect(solo_vendor).to have_key(:type)
    expect(solo_vendor[:type]).to be_a(String)

    expect(solo_vendor).to have_key(:attributes)
    expect(solo_vendor[:attributes]).to be_a(Hash)

    expect(solo_vendor[:attributes]).to have_key(:name)
    expect(solo_vendor[:attributes][:name]).to be_a(String)

    expect(solo_vendor[:attributes]).to have_key(:description)
    expect(solo_vendor[:attributes][:description]).to be_a(String)

    expect(solo_vendor[:attributes]).to have_key(:contact_name)
    expect(solo_vendor[:attributes][:contact_name]).to be_a(String)

    expect(solo_vendor[:attributes]).to have_key(:contact_phone)
    expect(solo_vendor[:attributes][:contact_phone]).to be_a(String)

    expect(solo_vendor[:attributes]).to have_key(:credit_accepted)
    expect(solo_vendor[:attributes][:credit_accepted]).to be_a(FalseClass).or be_a(TrueClass)
    end
  end
end