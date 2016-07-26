require 'assets/walker.rb'

namespace :walker do
  desc "Yelp"
  task :yelp => :environment do
    Walker.new.walk
  end
end
