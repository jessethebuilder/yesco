class IndexPage
  def initialize(machine, loc, industry, start = 0)
    @machine = machine
    @loc = loc
    @start = start
    @industry = industry
  end

  def parse_and_save
    set_page
    wait_until_page_ready
    set_links
    unless @machine.page.has_css?('.with-search-exception') ||
           @machine.page.has_css?('.broaden-search-suggestions')
      @links.each do |l|
        parse_and_save_listing(l)
      end
      # @links have been filtered to remove any that already exist in the databse
      @links.count
    else
      false
    end
  end

  private

  def parse_and_save_listing(url)
    listing = Listing.new(:machine => @machine, :url => url)
    l = listing.parse
    # save_listing? must be declared somewhere in scope.
    unless dont_save_listing?(l)
      l.save
      puts "SAVING: #{listing.name} - TOTAL_COUNT: #{Listing.count}"
    else
      puts "LISTING NOT SAVED"
    end
  end

  def set_links
    nodes = @machine.doc.css('.search-result')
    @links = []
    if nodes.count > 0
      nodes.map do |node|
        link = "#{Walker::BASE_URL}#{node.css('a.biz-name')[0].get_attribute('href')}".split('?')[0].gsub('http://', 'https://')
        if link.match(/https?:\/\/www\.yelp\.com\/adredir/).nil? && Listing.where(:yelp_website => link).count == 0 && !@links.include?(link)
          @links << link
        end
      end
    end
    puts "COUNT: #{@links.count}"
  end

  def set_page
    index_path = "#{Walker::BASE_URL}/search?find_desc=#{@industry}&find_loc=#{@loc}&start=#{@start}"
    puts "PARSING: #{index_path}"
    @machine.goto index_path
  end

  def wait_until_page_ready
    @machine.wait_until{ @machine.page.has_css?('.search-result') ||
                         @machine.page.has_css?('.with-search-exception') ||
                         @machine.page.has_css?('.broaden-search-suggestions')}
  end

  def dont_save_listing?(listing)
    # Special to prevent saveing data you don't want.
    # listing.state != 'NY'
  end
end
