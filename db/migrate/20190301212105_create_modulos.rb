class CreateModulos < ActiveRecord::Migration[5.2]
  def up
    create_table :modulos do |t|
      t.integer :type, default: 0
      t.string :title, null: false
      t.string :description
      t.string :slug
      t.integer :status, default: 0
      t.integer :order, default: 1
      t.attachment :image
      t.jsonb :info

      t.timestamps
    end

    change_table :themes do |t|
      t.belongs_to :modulo
      t.remove :category_type
    end

    %w[Começar Ler Escrever].each_with_index do |m, idx|
      Modulo.create title: m, order: idx + 1
    end

    add_index :modulos, :slug, unique: true
  end

  def down
    drop_table :modulos

    change_table :themes do |t|
      t.remove :modulo_id
      t.integer :category_type
    end
  end
end
