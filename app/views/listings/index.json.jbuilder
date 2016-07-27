json.array! @listings do |l|
  json.name l.name
  json.business_types l.business_types
  json.phone l.phone
  json.website l.website
  json.from_the_business l.from_the_business
  json.hours l.hours
  json.specialties l.specialties
  json.history l.history
  json.business_owner l.business_owner
  json.meet_the_business_owner l.meet_the_business_owner
  json.overall_rating l.overall_rating
  json.health_inspection l.health_inspection if l.health_inspection > 0
  json.takeout l.takeout ? true : false
  json.delivery l.delivery ? true : false
  json.accepts_credit_cards l.accepts_credit_cards ? true : false
  json.accepts_apple_pay l.accepts_apple_pay ? true : false
  json.parking l.parking
  json.bike_parking l.bike_parking ? true : false
  json.wheelchair_accessible l.wheelchair_accessible ? true : false

  json.location do
    json.address l.address
    json.city l.city
    json.state l.state
    json.zip l.zip
    json.cross_streets l.cross_streets
    json.neighborhoods l.neighborhoods
  end

  json.yelp_website l.yelp_website

  json.reviews do
    l.reviews.each do |r|
      json.author r.author
      json.rating r.rating
      json.content r.content
    end
  end
end
