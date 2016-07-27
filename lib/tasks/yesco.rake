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
      f.close

      first = Listing.first.id
      last = Listing.last.id
      (first..last).each_slice(1000) do |ids|
        slice_count = 0
        f = File.open(path, 'a')

        ids.each do |id|
          begin
            l = Listing.find(id)
            raw = l.jbuild
            pretty = ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
            json = pretty ? JSON.pretty_generate(JSON.parse(raw)) : raw
            f.write(json)
            wrote_count += 1
            slice_count += 1
            puts "WROTE: #{l.name} - ##{l.id}"
          rescue ActiveRecord::RecordNotFound => rnf

          rescue => e
            puts "FAILED TO WRITE: #{l.name} - ##{l.id} - ERROR: #{e.message}"
          end
        end

        f.close
        puts "SAVED AS JSON: #{slice_count} Records"
      end
      f = File.open(path, 'a')
      f.write(']')
      puts "WRITE COMPLETE: Wrote #{wrote_count} of #{total_count} Records"
    ensure
      f.close
    end
  end
end
