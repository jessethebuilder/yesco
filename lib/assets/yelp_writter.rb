require 'farm_ruby/s3_writer'

Aws.use_bundled_cert!

def write_all_yelp
  h = Hal.first
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
    out = formatted_json_output(r.jbuild)
    out
  end
  arr.to_json
end

def formatted_json_output(json)
    use_pretty_json? ? JSON.pretty_generate(JSON.parse(json.to_json)) : JSON.parse(json.to_json)
    # JSON.parse(json)
end

def use_pretty_json?
  ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
end
