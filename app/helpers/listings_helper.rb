module ListingsHelper
  def jbuild
    build_json.target!
  end

  def build_json
    Jbuilder.new do |json|
      json.name self.name
      json.business_types self.business_types
      json.phone self.phone
      json.website self.website
      json.from_the_business self.from_the_business
      json.hours self.hours
      json.specialties self.specialties
      json.history self.history
      json.business_owner self.business_owner
      json.meet_the_business_owner self.meet_the_business_owner
      json.overall_rating self.overall_rating
      json.health_inspection self.health_inspection if self.health_inspection > 0
      json.takeout self.takeout ? true : false
      json.delivery self.delivery ? true : false
      json.accepts_credit_cards self.accepts_credit_cards ? true : false
      json.accepts_apple_pay self.accepts_apple_pay ? true : false
      json.parking self.parking
      json.bike_parking self.bike_parking ? true : false
      json.wheelchair_accessible self.wheelchair_accessible ? true : false

      json.location do
        json.address self.address
        json.city self.city
        json.state self.state
        json.zip self.zip
        json.cross_streets self.cross_streets
        json.neighborhoods self.neighborhoods
      end

      json.yelp_website self.yelp_website
      json.reviews do
        json.array! self.reviews do |r|
          json.author r.author
          json.rating r.rating
          json.content r.content
        end
      end
    end
  end
end