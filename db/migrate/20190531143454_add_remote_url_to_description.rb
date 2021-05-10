class AddRemoteUrlToDescription < ActiveRecord::Migration[5.2]
  def change
    change_table :question_descriptions do |t|
      t.string :remote_audio_url
      t.string :remote_image_url
    end

    change_table :question_questions_item_templates do |t|
      t.attachment :custom_image
      t.string :custom_image_url
    end

    change_table :question_questions_items do |t|
      t.attachment :audio
      t.attachment :image
    
      t.string :remote_audio_url
      t.string :remote_image_url
    end
  end
end
