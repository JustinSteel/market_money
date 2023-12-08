class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    city = params[:city]
    state = params[:state]
    name = params[:name]
  
    if state.nil? || (!city.nil? && state.nil?)
      render json: { error: 'Invalid parameters' }, status: :unprocessable_entity
    else
      markets = Market.where('state LIKE ? AND city LIKE ? AND name LIKE ?', "%#{state}%", "%#{city}%", "%#{name}%")
      render json: MarketSerializer.new(markets), status: 200
    end
  end
end