# json @listing do |l|
  json.name @listing.name
  json.business_types @listing.business_types
  json.phone @listing.phone
  json.website @listing.website
  json.from_the_business @listing.from_the_business
  json.hours @listing.hours
  json.specialties @listing.specialties
  json.history @listing.history
  json.business_owner @listing.business_owner
  json.meet_the_business_owner @listing.meet_the_business_owner
  json.overall_rating @listing.overall_rating
  json.health_inspection @listing.health_inspection if @listing.health_inspection > 0
  json.takeout @listing.takeout ? true : false
  json.delivery @listing.delivery ? true : false
  json.accepts_credit_cards @listing.accepts_credit_cards ? true : false
  json.accepts_apple_pay @listing.accepts_apple_pay ? true : false
  json.parking @listing.parking
  json.bike_parking @listing.bike_parking ? true : false
  json.wheelchair_accessible @listing.wheelchair_accessible ? true : false

  json.location do
    json.address @listing.address
    json.city @listing.city
    json.state @listing.state
    json.zip @listing.zip
    json.cross_streets @listing.cross_streets
    json.neighborhoods @listing.neighborhoods
  end

  json.yelp_website @listing.yelp_website

  json.reviews do
    json.array! @listing.reviews do |r|
      json.author r.author
      json.rating r.rating
      json.content r.content
    end
  end
# end
