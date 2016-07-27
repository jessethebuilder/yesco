class AddSavedUrlsToHal < ActiveRecord::Migration[5.0]
  def change
    add_column :hals, :saved_urls, :text
  end
end
