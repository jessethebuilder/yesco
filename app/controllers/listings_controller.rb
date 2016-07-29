class ListingsController < ApplicationController
  # include ActionController::Live

  def index
    if params[:ids_only]
      @listings = render json: Listing.pluck(:id).to_json
    else
      per = Listing.yelp_write_speed
      @listings = Listing.page(params[:page]).per(per)
    end
  end

  def show
    @listing = Listing.find(params[:id])
  end

  private

end
