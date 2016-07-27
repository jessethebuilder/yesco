require 'assets/walker.rb'
require 'assets/yelp_writter.rb'

namespace :yesco do
  desc "Yelp"
  task :yelp => :environment do
    Walker.new.walk
  end

  desc "Yelp Reset"
  task :yelp_reset => :environment do
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end

  desc "Yelp Write"
  task :yelp_write => :environment do
    write_all_yelp
  end
end
