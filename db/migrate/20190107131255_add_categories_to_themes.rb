class AddCategoriesToThemes < ActiveRecord::Migration[5.2]
  def change
    change_table :themes do |t|
      t.integer :category_type, default: 0, null: false # Tipo: Ler, Escrever, etc.
      t.integer :target_audience, default: 0, null: false # Publico alvo: 1o ano, 2o ano
    end
  end
end
