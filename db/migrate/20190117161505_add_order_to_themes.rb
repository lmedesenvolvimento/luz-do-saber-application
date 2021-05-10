class AddOrderToThemes < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :order, :integer, default: 0
    add_column :units, :order, :integer, default: 0
  end
end
