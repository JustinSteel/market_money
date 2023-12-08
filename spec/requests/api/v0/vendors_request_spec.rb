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

    it "Vendors API should return a 404 if the vendor is not found" do
      get "/api/v0/vendors/112255336"

      expect(response).to have_http_status(404)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data).to have_key(:errors)
      expect(data[:errors].first).to have_key(:status)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first).to have_key(:title)
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=112255336")
    end

    it "can create a new vendor" do
      vendor_params = ({
                    name: 'And Then There Were None',
                    description: "some description",
                    contact_name: "Walter Mellon",
                    contact_phone: "123-456-7890",
                    credit_accepted: true 
                  })
      headers = {"CONTENT_TYPE" => "application/json"}
    
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
      expect(response).to have_http_status(201)
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it "can't create a new vendor without a name" do
      vendor_params = ({
                    description: "some description",
                    contact_name: "Walter Mellon",
                    contact_phone: "123-456-7890",
                    credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      data = JSON.parse(response.body, symbolize_names: true)
      created_vendor = Vendor.last
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(Vendor.count).to eq(6)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first).to eq("Name can't be blank")
    end

    it "can update an existing vendor" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "Banana Stand" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      vendor = Vendor.find_by(id: id)

      expect(response).to be_successful
      expect(vendor.name).to_not eq(previous_name)
      expect(vendor.name).to eq("Banana Stand")
    end

    it "can't update an existing vendor without a name" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)
      data = JSON.parse(response.body, symbolize_names: true)
      vendor = Vendor.find_by(id: id)
    
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(Vendor.count).to eq(7)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first).to eq("Name can't be blank")
    end

    it "can't update a vendor with an invalid id" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "Banana Stand" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/112223515", headers: headers, params: JSON.generate(vendor: vendor_params)
      data = JSON.parse(response.body, symbolize_names: true)
      vendor = Vendor.find_by(id: id)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(Vendor.count).to eq(7)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=112223515")
    end

    it "can destroy a vendor" do
      vendor = create(:vendor)
      
      expect(Vendor.count).to eq(7)
  
      delete "/api/v0/vendors/#{vendor.id}"
    
      
      expect(response.status).to eq(204)
      expect(Vendor.count).to eq(6)
    end

    it "can't destroy a vendor with an invalid id" do
      vendor = create(:vendor)

      expect(Vendor.count).to eq(7)

      delete "/api/v0/vendors/112223515"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(Vendor.count).to eq(7)
    end
  end
end