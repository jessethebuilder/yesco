class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.string :business_types
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :cross_streets
      t.string :neighborhoods
      t.string :phone
      t.string :website
      t.text :from_the_business
      t.text :hours
      t.text :specialties
      t.text :history
      t.text :meet_the_business_owner
      t.string :business_owner
      t.float :overall_rating
      t.float :health_inspection
      t.string :yelp_website
      t.boolean :takeout
      t.boolean :delivery
      t.boolean :accepts_credit_cards
      t.boolean :accepts_apple_pay
      t.string :parking
      t.boolean :bike_parking
      t.boolean :wheelchair_accessible

      t.timestamps
    end
  end
end
