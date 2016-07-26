class YelpWriter
  def initialize(db)
    @db = db
    @out = []
  end

  def write
    biz_arr = []
    businesses.each do |biz|

    end
  end



  private

  def write_address

  end

  def reviews(business)

  end

  def businesses
     @db.prepare('SELECT * FROM businesses').execute
  end
end
