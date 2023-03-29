class AddCoverToModulo < ActiveRecord::Migration[5.2]
  def change
    add_column :modulos, :cover_file_name, :varchar
    add_column :modulos, :cover_file_size, :int8
    add_column :modulos, :cover_content_type, :varchar
    add_column :modulos, :cover_update_at, :timestamp
    remove_column :modulos, :image_file_name
    remove_column :modulos, :image_content_type
    remove_column :modulos, :image_file_size
    remove_column :modulos, :image_updated_at
  end
end
