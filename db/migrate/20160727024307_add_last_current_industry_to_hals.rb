class AddLastCurrentIndustryToHals < ActiveRecord::Migration[5.0]
  def change
    add_column :hals, :current_industry, :string
  end
end
