def write_all_yelp
  JSONWalkerWriter.new(25, nil).save
end

class JSONWalkerWriter
  def initialize(thread_count, saved_records = nil)
    @thread_count = thread_count
    @base_url = 'http://yesco.herokuapp.com/listings'
    @output = "output/yelp_#{Time.now.to_i}.json"
    @saved_records = saved_records
  end

  def save
    counter = 0
    progress_count = 0
    total_count = ids.count
    save_count = 0
    error_count = 0
    threads = []

    start_save
    ids.each_slice(total_count / (@thread_count - 1)) do |slice|
      slice.each do |id|
        threads << Thread.new do
          counter += 1

          begin
            record = JSON.parse(RestClient.get("#{@base_url}/#{id}.json"))
            progress_count += 1
            save_counter += 1
            output = formatted_output(record)
            output += ",\n" unless counter == total_count
            F.append(@output, output)

            if progress_count == 100
              puts "#{counter} Records Saved to output folder"
              progress_count = 0
            end
          rescue RestClient::ServiceUnavailable => sue
            error_count += 1
            puts "ERROR: #{sue.message}"
          end
        end # each record
      end # each thread
    end  # threads

    threads.each do |t|
      t.join
    end

    F.append(@output, "]")
    puts "RECORDS SAVED: Saved #{save_count} of #{total_count} with #{error_count}"
  end

  private

  def ids
    @ids ||= JSON.parse(RestClient.get("#{@base_url}?ids_only=1"))
    clean_ids if @saved_records
    @ids
  end

  def clean_ids

  end

  def start_save
    puts "PREPARING: To write Yelp Records"
    F.append(@output, '[')
  end

  def formatted_output(json)
    print_pretty? ? JSON.pretty_generate(JSON.parse(json.to_json)) : json.to_json
  end

  def print_pretty?
    ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
  end

end
