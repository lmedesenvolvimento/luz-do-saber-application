class AddImageUrlAndAudioUrlToWord < ActiveRecord::Migration[5.2]
  def change
    change_table :word_images do |t|
      t.string :remote_url
    end

    change_table :word_audios do |t|
      t.string :remote_url
    end
  end
end
