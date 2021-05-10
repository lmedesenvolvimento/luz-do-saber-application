class CreateQuestionQuestionTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :question_question_templates do |t|
      t.belongs_to :user

      t.integer :type
      t.string :name
      t.string :slug, index: true
      t.attachment :image

      t.string :question_type
      t.string :question_subtype

      t.string :question_title
      t.string :question_description

      t.string :question_external_param_type
      t.integer :question_external_param_total

      t.integer :question_total_correct_items

      t.boolean :question_shuffle_keys
      t.boolean :question_shuffle_values

      t.integer :points_lost_a_star_by_attempt
      t.integer :points_lost_a_star_by_time

      t.string :item_template_key_font_size
      t.string :item_template_key_custom
      t.string :item_template_key_tags
      t.integer :item_template_key_total_per_line
      t.string :item_template_key_template_slug

      t.string :item_template_value_font_size
      t.string :item_template_value_custom
      t.string :item_template_value_tags
      t.integer :item_template_value_total_per_line
      t.string :item_template_value_template_slug

      t.timestamps
    end
  end
end
