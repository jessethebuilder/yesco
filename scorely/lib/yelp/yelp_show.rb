class YelpShow
  include Sqlite3Helper

  ATTRIBUTES = [:name, :business_types,
  :address, :city, :state, :zip, :cross_streets, :neighborhoods,
  :phone, :website, :from_the_business, :hours, :specialties, :history,
  :meet_the_business_owner, :business_owner,
  :overall_rating, :health_inspection, :yelp_website,
  :takeout, :delivery,
  :accepts_credit_cards, :accepts_apple_pay, :parking, :bike_parking, :wheelchair_accessible]

  ATTRIBUTES.each{ |a| attr_accessor(a) }

  def initialize(machine, db, url)
    @machine = machine
    @url = url
    @db = db
    set_page
    @doc = @machine.doc
  end

  def parse_and_save
    _parse
    id = _save
    YelpReview.parse_and_save_many(@doc.css('.review--with-sidebar')[1..5], id, @db)

    id
  end

  private

  def _save
    save_attributes(@db, 'businesses', ATTRIBUTES)
  end

  def set_page
    @machine.goto(@url)
  end

  def _parse
    self.name = @doc.css('.biz-page-title').text.strip
    _parse_contact_info
    _parse_business_info
  end

#--- Business Info Parsers ---------------
  def _parse_business_info
    self.from_the_business = @doc.css('.js-from-biz-owner p').text.strip
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
    health = @doc.css('.health-score .score-block')
    self.health_inspection = health.text.strip.to_f if health
  end

  def _parse_even_more_info
    info = @doc.css('.from-biz-owner-content')[0]

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
    owner = @doc.css('.meet-business-owner .user-display-name')[0]
    self.business_owner = owner.text.strip if owner
  end

  def _parse_more_info
    @doc.css('.ylist .short-def-list dl').each do |cell|
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
    rating = @doc.css('.biz-main-info [itemprop="ratingValue"]')[0]
    self.overall_rating = rating['content'].to_f if rating
  end

  def _parse_business_types
    self.business_types = @doc.css('.category-str-list a').map{ |h| h.text.strip }.join(',')
  end

  def _parse_hours
    rows = @doc.css('.hours-table tr')
    self.hours = rows.map{ |r| "#{r.css('th')[0].text.strip}: #{r.css('td')[0].text.strip}"}.join(',')
  end

#--- Contact Info Parsers -----------------
  def _parse_contact_info
    _parse_address
    self.phone = @doc.css('.biz-phone').text.strip
    self.website = @doc.css('.biz-website a').text.strip
  end

  def _parse_address
    self.address = @doc.css('span[itemprop="streetAddress"]').text.gsub('<br>', ' ').strip
    self.city = @doc.css('span[itemprop="addressLocality"]').text.strip
    self.state = @doc.css('span[itemprop="addressRegion"]').text.strip
    self.zip = @doc.css('span[itemprop="postalCode"]').text.strip
    self.cross_streets = @doc.css('.cross-streets').text.strip
    _parse_neighborhoods
  end

  def _parse_neighborhoods
    self.neighborhoods = @doc.css('.neighborhood-str-list').text.strip
  end
end
