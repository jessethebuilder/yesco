class IndexPage
  def initialize(machine, loc, start = 0)
    @machine = machine
    @loc = loc
    @start = start
  end

  def parse_and_save
    set_page
    wait_until_page_ready
    set_links
    unless @machine.page.has_css?('.with-search-exception')
      @links.each do |l|
        listing = Listing.new(:machine => @machine, :url => l)
        listing.parse.save!
        puts "SAVING: #{listing.name} - TOTAL_COUNT: #{Listing.count}"
      end
      true
    else
      false
    end
  end

  private

  def set_links
    nodes = @machine.doc.css('.search-result')
    @links = []
    if nodes.count > 0
      nodes.map do |node|
        link = "#{Walker::BASE_URL}#{node.css('a.biz-name')[0].get_attribute('href')}".split('?')[0]
        @links << link if Listing.where(:yelp_website => link).count == 0
      end
    end
  end

  def set_page
    index_path = "#{Walker::BASE_URL}/search?find_loc=#{@loc}&start=#{@start}"
    puts index_path
    puts "PARSING: #{index_path}"
    @machine.goto index_path
  end

  def wait_until_page_ready
    @machine.wait_until{ @machine.page.has_css?('.search-result') ||
                         @machine.page.has_css?('.with-search-exception') }
  end
end
