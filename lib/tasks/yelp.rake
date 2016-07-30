require 'assets/walker.rb'
require 'assets/yelp_writter.rb'

namespace :yelp do
  task :parse => :environment do
    Walker.new.walk
  end

  task :reset => :environment do
    reset_hal
  end

  task :write => :environment do
    write_all_yelp
  end

  def reset_hal
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end
end
