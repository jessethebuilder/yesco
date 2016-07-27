class ListingsController < ApplicationController
  # responds_to :json

  def index
    @listings = Listing.all
  end
end
