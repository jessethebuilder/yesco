class Listing < ApplicationRecord
  include ListingsHelper
  has_many :reviews
  attr_accessor :machine, :url

  def parse
    set_page
    parse_page

    reviews = @machine.doc.css('.review--with-sidebar')[1..5]
    if reviews
      reviews.each { |e| self.reviews << Review.new.parse(e) }
    end

    self
  end

  private

  def set_page
    @machine.goto(@url)
  end

  def parse_page
    self.name = @machine.doc.css('.biz-page-title').text.strip
    _parse_contact_info
    _parse_business_info
  end

#--- Business Info Parsers ---------------
  def _parse_business_info
    self.from_the_business = @machine.doc.css('.js-from-biz-owner p').text.strip
    _parse_business_types
    _parse_hours
    _parse_rating
    _parse_more_info
    self.yelp_website = @machine.page.current_url
    _parse_health_inspection
    _parse_business_owner
    _parse_even_more_info
  end

  def _parse_health_inspection
    health = @machine.doc.css('.health-score .score-block')
    self.health_inspection = health.text.strip.to_f if health
  end

  def _parse_even_more_info
    info = @machine.doc.css('.from-biz-owner-content')[0]

    if info
      headings = info.css('h3')
      contents = info.css('p')

      headings.each_with_index do |h, i|
        heading = h.text.strip.downcase.gsub(' ', '_')
        unless heading == 'meet_the_manager' || heading =~ /also_recommends$/

          self.send("#{heading}=", contents[i].text.strip)
        end
      end
    end
  end

  def _parse_business_owner
    owner = @machine.doc.css('.meet-business-owner .user-display-name')[0]
    self.business_owner = owner.text.strip if owner
  end

  def _parse_more_info
    @machine.doc.css('.ylist .short-def-list dl').each do |cell|
      case cell.css('dt').text.strip
      when 'Delivery'
        self.delivery = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Take-out'
        self.takeout = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Accepts Credit Cards'
        self.accepts_credit_cards = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Accepts Apple Pay'
        self.accepts_apple_pay = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Wheelchair Accessible'
        self.wheelchair_accessible = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Bike Parking'
        self.bike_parking = cell.css('dd').text.strip == 'Yes' ? 1 : nil
      when 'Parking'
        self.parking = cell.css('dd').text.strip
      end
    end

  end

  def _parse_rating
    rating = @machine.doc.css('.biz-main-info [itemprop="ratingValue"]')[0]
    self.overall_rating = rating['content'].to_f if rating
  end

  def _parse_business_types
    self.business_types = @machine.doc.css('.category-str-list a').map{ |h| h.text.strip }.join(',')
  end

  def _parse_hours
    rows = @machine.doc.css('.hours-table tr')
    self.hours = rows.map{ |r| "#{r.css('th')[0].text.strip}: #{r.css('td')[0].text.strip}"}.join(',')
  end

#--- Contact Info Parsers -----------------
  def _parse_contact_info
    _parse_address
    self.phone = @machine.doc.css('.biz-phone').text.strip
    self.website = @machine.doc.css('.biz-website a').text.strip
  end

  def _parse_address
    self.address = @machine.doc.css('span[itemprop="streetAddress"]').text.gsub('<br>', ' ').strip
    self.city = @machine.doc.css('span[itemprop="addressLocality"]').text.strip
    self.state = @machine.doc.css('span[itemprop="addressRegion"]').text.strip
    self.zip = @machine.doc.css('span[itemprop="postalCode"]').text.strip
    self.cross_streets = @machine.doc.css('.cross-streets').text.strip
    _parse_neighborhoods
  end

  def _parse_neighborhoods
    self.neighborhoods = @machine.doc.css('.neighborhood-str-list').text.strip
  end
end
