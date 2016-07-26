class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.string :name
      t.text :content
      t.integer :yelp_id
      t.float :rating

      t.timestamps
    end
  end
end
