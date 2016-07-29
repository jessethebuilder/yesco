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
    # use_pretty_json? ? JSON.pretty_generate(JSON.parse(json.to_json)) : json.to_json
    JSON.parse(json)
end

def use_pretty_json?
  ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
end




#
# class JSONWalkerWriter
#   def initialize(thread_count, saved_records = nil)
#     @thread_count = thread_count
#     @base_url = 'http://yesco.herokuapp.com/listings'
#     @output = "output/yelp_#{Time.now.to_i}.json"
#     @saved_records = saved_records
#   end
#
#   def save
#     counter = 0
#     progress_count = 0
#     total_count = ids.count
#     save_count = 0
#     error_count = 0
#     threads = []
#
#     start_save
#     ids.each_slice(total_count / (@thread_count - 1)) do |slice|
#       slice.each do |id|
#         threads << Thread.new do
#           counter += 1
#
#           begin
#             record = JSON.parse(RestClient.get("#{@base_url}/#{id}.json"))
#             progress_count += 1
#             save_counter += 1
#             output = formatted_output(record)
#             output += ",\n" unless counter == total_count
#             F.append(@output, output)
#
#             if progress_count == 100
#               puts "#{counter} Records Saved to output folder"
#               progress_count = 0
#             end
#           rescue RestClient::ServiceUnavailable => sue
#             error_count += 1
#             puts "ERROR: #{sue.message}"
#           end
#         end # each record
#       end # each thread
#     end  # threads
#
#     threads.each do |t|
#       t.join
#     end
#
#     F.append(@output, "]")
#     puts "RECORDS SAVED: Saved #{save_count} of #{total_count} with #{error_count}"
#   end
#
#   private
#
#   def ids
#     puts "FETCHING: ids"
#     puts "#{@base_url}.json?ids_only=1"
#     @ids ||= JSON.parse(RestClient.get("#{@base_url}.json?ids_only=1"))
#     clean_ids if @saved_records
#     puts @ids
#     @ids
#   end
#
#   def clean_ids
#
#   end
#
#   def start_save
#     puts "PREPARING: To write Yelp Records"
#     F.append(@output, '[')
#   end
#

#
# end
