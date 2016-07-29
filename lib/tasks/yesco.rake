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
    reset_hal
  end

  desc "Yelp Write"
  # heroku run bundle exec rake yesco:yelp_write
  task :yelp_write => :environment do
    reset_hal
    write_all_yelp
  end

  def reset_hal
    h = Hal.first
    h.saved_zips = []
    h.current_industry = nil
    h.save
  end
end
