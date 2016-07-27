require 'assets/walker.rb'

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
    path = Rails.root.join('public', 'yelp.json')
    total_count = Listing.count
    wrote_count = 0
    begin
      f = File.open(path, 'w')
      f.write('')
      f.close

      f = File.open(path, 'a')
      f.write('[')
      Listing.all.map(&:id).each do |id|
        begin
          l = Listing.find(id)
          f.write(JSON.pretty_generate(JSON.parse(l.jbuild)))
          wrote_count += 1
          puts "WROTE: #{l.name} - ##{l.id}"
        rescue => e
          puts "FAILED TO WRITE: #{l.name} - ##{l.id} - ERROR: #{e.message}"
        end
      end

      f.write(']')
      puts "WRITE COMPLETE: Wrote #{wrote_count} of #{total_count} Records"
    ensure
      f.close
    end
  end
end
