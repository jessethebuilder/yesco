require 'assets/walker.rb'

namespace :walker do
  desc "Yelp"
  task :yelp => :environment do
    Walker.new.walk
  end

  desc "Reset Yelp"
  task :reset_yelp => :environment do
    h = Hal.first
    h.saved_zips = []
    h.save
  end
end
