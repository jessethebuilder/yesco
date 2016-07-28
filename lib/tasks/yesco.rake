require 'assets/walker.rb'
require 'assets/yelp_writter.rb'

namespace :yesco do
  # heroku run bundle exec rake yesco:yelp
  desc "Yelp"
  task :yelp => :environment do
    Walker.new.walk
  end

  desc "Yelp Reset"
  # heroku run bundle exec rake yesco:yelp_reset
  task :yelp_reset => :environment do
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end

  desc "Yelp Write"
  # run rake yesco:yelp_write
  task :yelp_write => :environment do
    write_all_yelp
  end
end
