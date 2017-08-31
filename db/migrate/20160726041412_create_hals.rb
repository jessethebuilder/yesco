class CreateHals < ActiveRecord::Migration[5.0]
  def change
    create_table :hals do |t|
      t.text :saved_zips
    end
  end
end
