class AddRemoteUrlToUnits < ActiveRecord::Migration[5.2]
  def change
    change_table :themes do |t|
      t.string :remote_cover_url
    end

    change_table :units do |t|
      t.string :remote_cover_url
    end
  end
end
