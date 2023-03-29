class AddColorToModulo < ActiveRecord::Migration[5.2]
  def change
    add_column :modulos, :color, :varchar
  end
end
