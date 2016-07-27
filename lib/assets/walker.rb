class Walker
  BASE_URL =  "http://www.yelp.com"

  INDUSTRIES = ['Restaurants', 'Hotels+%26+Travel', 'Bars', 'health care', 'fitness', 'retail', '']

  def initialize
    set_machine
  end

  def walk
    INDUSTRIES.each do |industry|
      while loc = get_next_loc
        counter = 0
        while counter
          begin
            parse_result = IndexPage.new(@machine, loc, industry, counter).parse_and_save
          rescue Capybara::Poltergeist::StatusFailError => cap_err
            puts "WALKER ERROR: #{cap_err.message}"
            set_machine
            parse_result = :no_count
          end

          if parse_result > 0
            counter += 10 unless parse_result == :no_count # Occurs on Capy Error
          else #if false or 0 results
            counter = false
          end
        end

        hal = Hal.first
        hal.saved_zips << loc
        hal.save

        puts "All #{industry} for #{loc} Saved"
      end
      hal = Hal.first
      hal.saved_zips = []
      hal.save
      puts "All Records for #{industry} Saved"
    end

    puts "Walker Complete!"
  end

  private

  def get_next_loc
    hal = Hal.first
    (hal.unsaved_zips - hal.saved_zips).sample
  end

  def phantomjs_path
    if Rails.env.production?
      Phantomjs.path
    end

  end

  def set_machine
    @machine = JsScrape.new(timeout: 180, :proxy => false, :debug => false)
  end
end
