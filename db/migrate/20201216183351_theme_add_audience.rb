class ThemeAddAudience < ActiveRecord::Migration[5.2]
  def change
    change_table :themes do |t|
      t.belongs_to :theme_audience
    end
  end
end
