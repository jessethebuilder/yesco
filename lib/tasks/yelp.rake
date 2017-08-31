require 'assets/walker.rb'
require 'assets/yelp_writter.rb'

namespace :yelp do
  task :parse => :environment do
    Walker.new(['real estate agent'], F.read('data/nyc.zips').split("\n")).walk
  end

  task :reset => :environment do
    reset_hal
  end

  task :reset_all => :environment do
    Listing.destroy_all
  end

  task :write => :environment do
    write_all_yelp
  end

  task write_csv: :environment do
    Listing.to_csv do |row|
      row[2] = row[2].gsub('(', '').gsub(')', '').gsub(' ', '-')
    end
  end


  def reset_hal
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end
end
