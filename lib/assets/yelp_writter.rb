require 'farm_ruby/s3_writer'

Aws.use_bundled_cert!

def write_all_yelp
  h = Hal.first
  (h.unsaved_zips - h.saved_zips)
  h.unsaved_zips.each do |zip|
    S3Writer.new('us-west-2', 'yesco-yelp', zip.to_s, ENV['AWS_ID'], ENV['AWS_SECRET']).write do
      # You need to define these ENV variables with your own AWS info
       zip_to_json(zip)
    end
  end
end

def zip_to_json(zip)
  records = Listing.where(:zip => zip)
  arr = records.map do |r|
    JSON.parse(r.jbuild)
  end
  arr.to_json
end
