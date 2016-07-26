class YelpReview
  include Sqlite3Helper
  ATTRIBUTES = [:author, :rating, :content, :business_id]
  ATTRIBUTES.each{ |a| attr_accessor(a) }

  def initialize(html, business_id, db)
    @html = html
    @business_id = business_id
    @db = db
  end

  def parse_and_save
    parse
    save
  end

  def parse
    @author = @html.css('meta[itemprop="author"]')[0]['content'].strip
    @rating = @html.css('div[itemprop="reviewRating"] i')[0]['title'].gsub(' star rating', '').strip.to_f
    @content = @html.css('p[itemprop="description"]')[0].text.strip
  end

  def save
    save_attributes(@db, 'reviews', ATTRIBUTES)
  end

  def self.parse_and_save_many(reviews, business_id, db)
    reviews.each { |r| self.new(r, business_id, db).parse_and_save } if reviews
  end
end
