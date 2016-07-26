require_relative 'scorely_yelp.rb'

class ScorelyYelpMulti

  def initialize(db)
    @db = db
  end

  def parse(thread_count = 5)
    all_zips = clean_zips

    x = all_zips.count / thread_count

    threads = []

    thread_count.times do |n|
      start = x * n
      threads << Thread.new do
        ScorelyYelp.new(@db).parse(all_zips[start..(start + x)])
      end
    end

    threads.each_with_index do |t, i|
      t.join
      puts "Thread #{i} complete"
    end

    puts "ALL TREADS COMPLETE!!!"
  end

  private

  def clean_zips
    all_zips = F.read('data/yelp_zips.txt').split("\n")
    finished_zips = F.read('data/finished_yelp_zips.txt').split("\n")

    all_zips.delete_if do |z|
      finished_zips.include?(z)
    end

    all_zips
  end
end
