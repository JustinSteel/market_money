class Api::V0::MarketVendorsController < ApplicationController
  def index
    render json: MarketVendorsSerializer.new(Market.find(params[:market_id]).vendors)
  end

  def create
    market_id = params[:market_id]
    vendor_id = params[:vendor_id]
    if market_id.blank? || vendor_id.blank?
      render json: {message: "Validation failed: Market can't be blank, Vendor can't be blank"}, status: :bad_request
    else
      begin
        market = Market.find(market_id)
        vendor = Vendor.find(vendor_id)
        raise ActiveRecord::RecordNotUnique if MarketVendor.where(market: market, vendor: vendor).exists?
        MarketVendor.create!(market: market, vendor: vendor)
        render json: {message: "Successfully added venfor to market"}, status: :created
      rescue ActiveRecord::RecordInvalid => exception
        render json: ErrorSerializer.new(ErrorMessage.new(exception.message, :unprocessable_entity)).serialize, status: 404
      rescue ActiveRecord::RecordNotUnique => exception
        render json: ErrorSerializer.new(ErrorMessage.new("Market Vendor with the same market_id and vendor_id already exists"))
      end
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(id: params[:id])
  
    if market_vendor.nil?
      render json: { errors: "Market Vendor with id #{params[:id]} not found" }, status: :not_found
    else
      market_vendor.destroy
    end
  end
end