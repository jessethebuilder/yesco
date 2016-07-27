module ApplicationHelper
  ::LISTING_ATTRIBUTES = [:name, :business_types, :address, :city, :state, :zip, :cross_streets, :neighborhoods,
  :phone, :website, :from_the_business, :hours, :specialties, :history,
  :meet_the_business_owner, :business_owner, :overall_rating, :health_inspection,
  :yelp_website, :takeout, :delivery, :accepts_credit_cards, :accepts_apple_pay,
  :parking, :bike_parking, :wheelchair_accessible]

  ::REVIEW_ATTRIBUTES = [:author, :content, :rating]
end
