def write_all_yelp
  JSONWalkerWriter.new('http://yesco.herokuapp.com/listings', "yelp").save
end

class JSONWalkerWriter
  def initialize(base_url, output = "walker")
    @base_url = base_url
    @output = "output/#{output}_#{Time.now.to_i}"
  end

  def save
    start_save
    total_count = ids.count
    puts "PREPARING: To write #{total_count} Records"

    counter = 0
    progress_counter = 0

    threads = []
    ids.each_slice(10000) do |id_slice|
      threads << Thread.new do
        id_slice.each do |id|
          record = RestClient.get("#{@base_url}/#{id}.json")

          output = formatted_output(record)
          output += ",\n" unless counter == total_count - 1

          F.append(file_path, output)

          counter += 1
          progress_counter += 1
          if progress_counter == 100
            puts "#{counter} of #{total_count} Records Saved to output folder"
            progress_counter = 0
          end
        end
      end
    end

    threads.each{ |t| t.join }
    end_save
  end

  private

  def file_path
    @file_path ||= "#{@output}.json"
  end

  def ids
    @ids ||= JSON.parse(RestClient.get("#{@base_url}.json"))
  end

  def start_save
    F.append(file_path, '[')
  end

  def end_save
    F.append(file_path, ']')
  end

  def formatted_output(json)
    json
    print_pretty? ? JSON.pretty_generate(JSON.parse(json)) : json
  end

  def print_pretty?
    ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
  end

end
