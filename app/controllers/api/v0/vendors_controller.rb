class Api::V0::VendorsController < ApplicationController
  def index
    render json: VendorSerializer.new(Vendor.all)
  end
  
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save
    render json: VendorSerializer.new(vendor), status: :created

    else 
      render json: { errors: vendor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    render json: VendorSerializer.new(Vendor.update(params[:id], vendor_params))
  end

  def destroy
    render json: Vendor.delete(params[:id])
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end