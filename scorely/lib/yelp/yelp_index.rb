class YelpIndex
  def initialize(machine, db, loc, start = 0)
    @loc = loc
    @start = start
    @machine = machine
    @doc = @machine.doc
    @db = db
    # sleep 1

    # q = @db.prepare('SELECT * FROM finished_zips WHERE zip=? LIMIT 1')
    # q.bind_params(1, @loc)
    # if q.execute.count == 0
      set_page
      set_links
    # else
    #   puts "#{@loc} COMPLETE!!"
    # end
  end

  def parse_and_save
    @machine.wait_until{ @machine.page.has_css?('.search-result') || @machine.page.has_css?('.with-search-exception') }

    unless @machine.page.has_css?('.with-search-exception')
      @links.each do |l|
        # begin
          show = YelpShow.new(@machine, @db, l)
          id = show.parse_and_save
          puts "Saving #{show.name} as Record ##{id}"
        # rescue => e
        #   F.log_error(e, note: "FALIED TO SAVE AT: #{l}")
        #   @machine = JsScrape.new(timeout: 180, :proxy => false)
        #   @doc = @machine.doc
        # end
      end
      true
    else
      F.append('data/finished_yelp_zips.txt', "#{@loc}\n")
      puts "Final Record for #{@loc} before Start: #{@start}"
      false
    end
  end

  private

  def set_links
    nodes = @doc.css('.search-result')
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
    # begin
      puts "PARSING: #{index_path}"
      @machine.goto(index_path)
    # rescue StandardError => e
    #   @machine = JsScrape.new(timeout: 180, :proxy => false)
    #   @doc = @machine.doc
    #   F.log_error(e, :note => "FALIED INDEX: #{@loc}:#{@start}")
    # end
  end

  def index_path
    "#{ScorelyYelp::BASE_URL}/search?find_loc=#{@loc}&start=#{@start}"
  end
end
