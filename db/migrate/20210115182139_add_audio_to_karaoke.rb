class AddAudioToKaraoke < ActiveRecord::Migration[5.2]
  def change
    change_table :karaokes do |t|
      t.attachment :audio
    end
  end
end
