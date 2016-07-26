class Review < ApplicationRecord
  belongs_to :listing

  def initialize(html)
    parse(html)
  end

  def parse
    self.author = @html.css('meta[itemprop="author"]')[0]['content'].strip
    self.rating = @html.css('div[itemprop="reviewRating"] i')[0]['title'].gsub(' star rating', '').strip.to_f
    self.content = @html.css('p[itemprop="description"]')[0].text.strip
  end
end
