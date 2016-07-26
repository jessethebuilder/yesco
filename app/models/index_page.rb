class IndexPage
  def initialize(machine, loc, start = 0)
    @loc = loc
    @start = start
    @machine = machine

    set_page
    set_links
  end

  def parse_and_save
    @machine.wait_until{ @machine.page.has_css?('.search-result') || @machine.page.has_css?('.with-search-exception') }

    unless @machine.page.has_css?('.with-search-exception')
      @links.each do |l|
        show = YelpShow.new(@machine, @db, l)
        id = show.parse_and_save
        puts "Saving #{show.name} as Record ##{id}"
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
        link = "#{ScorelyYelp::BASE_URL}#{node.css('a.biz-name')[0].get_attribute('href')}".split('?')[0]
        q = @db.prepare('SELECT * FROM businesses WHERE yelp_website=? LIMIT 1')
        q.bind_param(1, link)
        @links << link if q.execute.count == 0
      end
    end
  end

  def set_page
    puts "PARSING: #{index_path}"
    @machine.goto(index_path)
  end

  def index_path
    "#{ScorelyYelp::BASE_URL}/search?find_loc=#{@loc}&start=#{@start}"
  end
end
