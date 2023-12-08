class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors.all)
  end
  
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save
    render json: VendorSerializer.new(vendor), status: :created

    else 
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor_update = vendor.update(vendor_params)

    if vendor_update
    render json: VendorSerializer.new(Vendor.update(params[:id], vendor_params))

    else 
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])

    if vendor.destroy

    else 
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end