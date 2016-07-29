require 'farm_ruby/s3_writer'

Aws.use_bundled_cert!

def write_all_yelp
  h = Hal.first

  zip = (h.unsaved_zips - h.saved_zips).sample
  while zip
    h = Hal.first
    h.saved_zips << zip
    h.save
    S3Writer.new('us-west-2', 'yesco-yelp', "#{zip}.json", ENV['AWS_ID'], ENV['AWS_SECRET']).write do
      zip_to_json(zip)
    end

    zip = (h.unsaved_zips - h.saved_zips).sample
  end
end

def zip_to_json(zip)
  records = Listing.where(:zip => zip)
  arr = records.map do |r|
    JSON.parse(r.jbuild)
  end
  arr.to_json
end
