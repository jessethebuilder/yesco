require 'assets/walker.rb'

namespace :walker do
  desc "Yelp"
  task :yelp => :environment do
    Walker.new.walk
  end

  desc "Reset Yelp"
  task :yelp_reset => :environment do
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end
end
