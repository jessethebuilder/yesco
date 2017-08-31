class AddDepthToHal < ActiveRecord::Migration[5.0]
  def change
    add_column :hals, :depth, :integer, default: 3
  end
end
