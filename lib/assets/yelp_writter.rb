def write_all_yelp
  JSONWalkerWriter.new().save
end

class JSONWalkerWriter
  def initialize(thread_count = 5)
    @thread_count = thread_count
    @base_url = 'http://yesco.herokuapp.com/listings'
    @output = "output/yelp_#{Time.now.to_i}.json"
  end

  def save
    start_save
    # total_count = ids.count

    counter = 0
    page_counter = 0
    progress_counter = 0

    threads = []
    @thread_count.times do
      threads << Thread.new do
        while true
          page_counter += 1
          begin
            record_array = JSON.parse(RestClient.get("#{@base_url}.json?page=#{page_counter}"))
          rescue RestClient::ServiceUnavailable => sue
            page_counter -= 1
            puts "ERROR: #{sue.message}"
            next
          end

          break if record_array.count == 0

          record_array.each do |record|
            output = formatted_output(record)
            #
            # unless counter == total_count && record_array.last == record
            output += ",\n"
            # end

            F.append(@output, output)
            progress_counter += 1
            counter += 1

            if progress_counter == 100
              puts "#{counter} Records Saved to output folder"
              progress_counter = 0
            end
          end # each record
        end # while
      end # each thread
    end  # threads

    threads.each{ |t| t.join }
    end_save
  end

  private

  def start_save
    puts "PREPARING: To write Yelp Records"
    F.append(@output, '[')
  end

  def end_save
    puts "END SAVE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    whole = F.read(@output)

    F.write(@output, "#{whole.chomp.chop}]")
  end

  def formatted_output(json)
    print_pretty? ? JSON.pretty_generate(JSON.parse(json.to_json)) : json.to_json
  end

  def print_pretty?
    ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
  end

end
