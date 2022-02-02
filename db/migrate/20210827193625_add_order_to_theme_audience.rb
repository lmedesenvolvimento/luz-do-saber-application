class AddOrderToThemeAudience < ActiveRecord::Migration[5.2]
  def change
    add_column :theme_audiences, :order, :integer, default: 0
  end
end
