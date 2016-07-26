class Walker
  BASE_URL =  "http://www.yelp.com"

  def initialize
    set_machine
  end

  def walk
    while loc = get_next_loc
      counter = 0
      while counter
        begin
          parse_result = IndexPage.new(@machine, loc, counter).parse_and_save
        rescue Capybara::Poltergeist::StatusFailError => cap_err
          puts "WALKER ERROR: #{cap_err.message}"
          set_machine
          parse_result = :no_count
        end

        if parse_result
          counter += 10 unless parse_result == :no_count
        else
          counter = false
        end
      end
      hal.saved_zips << loc
      hal.save
      puts "All Records for #{loc} Saved"
    end

    puts "Walker Complete!"
  end

  private

  def get_next_loc
    (hal.unsaved_zips - hal.saved_zips).sample
  end

  def set_machine
    @machine = JsScrape.new(timeout: 180, :proxy => false)
  end

  def hal
    Hal.first
  end
end
