require 'sqlite3'

module ScorelyYelpDbHelper
  def set_db
    @db = build_db
  end

  def build_db
    db = SQLite3::Database.new('db/yelp.sqlite')

    begin
      rows = db.execute <<-SQL
        create table businesses (
          name varchar(50),
          business_types text,
          address varchar(50),
          city varchar(50),
          state varchar(50),
          zip varchar(50),
          cross_streets varchar(50),
          neighborhoods varchar(50),
          phone varchar(50),
          website varchar(50),
          from_the_business text,
          hours text,
          specialties varchar(50),
          history text,
          meet_the_business_owner text,
          business_owner text,
          overall_rating numeric,
          health_inspection numeric,
          yelp_website varchar(50),
          takeout boolean,
          delivery boolean,
          accepts_credit_cards boolean,
          accepts_apple_pay boolean,
          parking varchar(50),
          bike_parking boolean,
          wheelchair_accessible boolean
          );
        SQL

        rows = db.execute <<-SQL
          create table reviews(
            author varchar(50),
            rating numeric,
            content text,
            business_id integer
          );
        SQL

        puts 'DB created!'
      rescue SQLite3::SQLException => e
        puts 'Using existing DB'
      end

      # begin
      #   rows = db.execute <<-SQL
      #     create table finished_zips(
      #       zip varchar(5)
      #     );
      #   SQL
      #   puts 'Creating Index Urls Add-On DB'
      # rescue SQLite3::SQLException => e
      #   puts 'Using Index Urls Add-On DB'
      # end

      db
    end
end
