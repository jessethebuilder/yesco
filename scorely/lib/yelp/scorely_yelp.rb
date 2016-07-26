require_relative 'yelp_index'
require_relative 'yelp_show'
require_relative 'yelp_review'

class ScorelyYelp
  BASE_URL =  "http://www.yelp.com"

  def initialize(db)
    @machine = JsScrape.new(timeout: 180, :proxy => false)
    @db = db
  end

  def parse(zips)
    walk(zips)
  end

  def walk(locations)
    locations.each do |loc|
      counter = 0
      while counter
        begin
          parse_result = YelpIndex.new(@machine, @db, loc, counter).parse_and_save
        rescue Capybara::Poltergeist::StatusFailError => cap_err
          F.log_error(cap_err, :note => 'Walk Error')
          @machine = JsScrape.new(timeout: 180, :proxy => false)
          parse_result = :no_count
        end

        if parse_result
          counter += 10 unless parse_result == :no_count
        else
          counter = false
        end
      end
    end
  end
end
