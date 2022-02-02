class AddSlugToThemeAudience < ActiveRecord::Migration[5.2]
  def change
    change_table :theme_audiences do |t|
      t.string :slug, index: true
    end
  end
end
