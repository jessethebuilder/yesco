class ListingsController < ApplicationController
  # include ActionController::Live

  def index
    # @listings = render json: Listing.pluck(:id).to_json
    per = ENV['YELP_WRITE_SPEED'] || 100
    @listings = Listing.page(params[:page]).per(per)
  end

  def show
    @listing = Listing.find(params[:id])
  end

  private

  def formatted_output(json)
    # pretty_print ? JSON.pretty_generate(JSON.parse(json)) : json
    # json
  end

  def print_pretty
    ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
  end
end
