class Review < ApplicationRecord
  belongs_to :listing

  def parse(noko_html)
    self.author = noko_html.css('meta[itemprop="author"]')[0]['content'].strip
    self.rating = noko_html.css('div[itemprop="reviewRating"] i')[0]['title'].gsub(' star rating', '').strip.to_f
    self.content = noko_html.css('p[itemprop="description"]')[0].text.strip
    self
  end
end
