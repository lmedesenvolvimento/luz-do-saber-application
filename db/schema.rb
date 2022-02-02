# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_16_150819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_pages", force: :cascade do |t|
    t.bigint "book_id"
    t.integer "order"
    t.string "book_page_file_name"
    t.string "book_page_content_type"
    t.bigint "book_page_file_size"
    t.datetime "book_page_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_pages_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.bigint "user_id"
    t.string "slug"
    t.string "title", null: false
    t.string "subtitle"
    t.integer "total_pages"
    t.jsonb "authors", default: []
    t.jsonb "pages", default: []
    t.string "remote_cover_url"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.bigint "cover_file_size"
    t.datetime "cover_updated_at"
    t.string "remote_pdf_url"
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.bigint "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string "zip_pages_file_name"
    t.string "zip_pages_content_type"
    t.bigint "zip_pages_file_size"
    t.datetime "zip_pages_updated_at"
    t.integer "status"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_books_on_slug"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "groups_participants", force: :cascade do |t|
    t.integer "type", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_participants_on_group_id"
    t.index ["user_id"], name: "index_groups_participants_on_user_id"
  end

  create_table "karaoke_images", force: :cascade do |t|
    t.bigint "karaoke_id", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["karaoke_id"], name: "index_karaoke_images_on_karaoke_id"
  end

  create_table "karaokes", force: :cascade do |t|
    t.string "title", null: false
    t.string "status", default: "0"
    t.string "lyrics_file_name"
    t.string "lyrics_content_type"
    t.bigint "lyrics_file_size"
    t.datetime "lyrics_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "audio_file_name"
    t.string "audio_content_type"
    t.bigint "audio_file_size"
    t.datetime "audio_updated_at"
  end

  create_table "modulos", force: :cascade do |t|
    t.integer "type", default: 0
    t.string "title", null: false
    t.string "description"
    t.string "slug"
    t.integer "status", default: 0
    t.integer "order", default: 1
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.jsonb "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_modulos_on_slug", unique: true
  end

  create_table "question_descriptions", force: :cascade do |t|
    t.integer "type", default: 0
    t.string "text", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "audio_file_name"
    t.string "audio_content_type"
    t.bigint "audio_file_size"
    t.datetime "audio_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remote_audio_url"
    t.string "remote_image_url"
  end

  create_table "question_item_templates", force: :cascade do |t|
    t.integer "type", default: 0, null: false
    t.string "name", null: false
    t.string "description"
    t.string "slug"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_question_item_templates_on_slug"
    t.index ["type"], name: "index_question_item_templates_on_type"
  end

  create_table "question_pointings", force: :cascade do |t|
    t.bigint "question_question_id", null: false
    t.integer "type", default: 0, null: false
    t.integer "quantity", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_question_id"], name: "index_question_pointings_on_question_question_id"
  end

  create_table "question_question_templates", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "type"
    t.string "name"
    t.string "slug"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "question_type"
    t.string "question_subtype"
    t.string "question_title"
    t.string "question_description"
    t.string "question_external_param_type"
    t.integer "question_external_param_total"
    t.integer "question_total_correct_items"
    t.boolean "question_shuffle_keys"
    t.boolean "question_shuffle_values"
    t.integer "points_lost_a_star_by_attempt"
    t.integer "points_lost_a_star_by_time"
    t.string "item_template_key_font_size"
    t.string "item_template_key_custom"
    t.string "item_template_key_tags"
    t.integer "item_template_key_total_per_line"
    t.string "item_template_key_template_slug"
    t.string "item_template_value_font_size"
    t.string "item_template_value_custom"
    t.string "item_template_value_tags"
    t.integer "item_template_value_total_per_line"
    t.string "item_template_value_template_slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_question_question_templates_on_slug"
    t.index ["user_id"], name: "index_question_question_templates_on_user_id"
  end

  create_table "question_questions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "unit_id", null: false
    t.bigint "question_type_id", null: false
    t.bigint "question_subtype_id", null: false
    t.integer "order", null: false
    t.string "general_info"
    t.integer "external_param_type", default: 99
    t.integer "external_param_total", default: 0
    t.boolean "shuffle_key_items", default: false
    t.boolean "shuffle_value_items", default: false
    t.integer "total_correct_items"
    t.jsonb "info", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "question_question_template_id"
    t.integer "status", default: 1
    t.string "subtitle"
    t.index ["question_question_template_id"], name: "index_question_questions_on_question_question_template_id"
    t.index ["question_subtype_id"], name: "index_question_questions_on_question_subtype_id"
    t.index ["question_type_id"], name: "index_question_questions_on_question_type_id"
    t.index ["unit_id"], name: "index_question_questions_on_unit_id"
    t.index ["user_id"], name: "index_question_questions_on_user_id"
  end

  create_table "question_questions_descriptions", force: :cascade do |t|
    t.bigint "question_question_id"
    t.bigint "question_description_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_description_id"], name: "index_questions_descriptions_on_question_description_id"
    t.index ["question_question_id"], name: "index_question_questions_descriptions_on_question_question_id"
  end

  create_table "question_questions_groups", force: :cascade do |t|
    t.bigint "question_question_id", null: false
    t.bigint "group_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_question_questions_groups_on_group_id"
    t.index ["question_question_id"], name: "index_question_questions_groups_on_question_question_id"
  end

  create_table "question_questions_item_templates", force: :cascade do |t|
    t.bigint "question_question_id", null: false
    t.bigint "question_item_template_id"
    t.integer "type", default: 0
    t.integer "font_size", default: 1
    t.integer "total_per_line", default: 1
    t.string "custom"
    t.jsonb "tags"
    t.jsonb "info", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_image_file_name"
    t.string "custom_image_content_type"
    t.bigint "custom_image_file_size"
    t.datetime "custom_image_updated_at"
    t.string "custom_image_url"
    t.index ["question_item_template_id"], name: "idx_questions_item_templates_on_item_template_id"
    t.index ["question_question_id"], name: "index_question_questions_item_templates_on_question_question_id"
  end

  create_table "question_questions_items", force: :cascade do |t|
    t.bigint "question_question_id"
    t.bigint "word_id"
    t.integer "word_type", default: 0
    t.integer "word_source_type", default: 0
    t.integer "key_id"
    t.integer "type"
    t.jsonb "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "audio_file_name"
    t.string "audio_content_type"
    t.bigint "audio_file_size"
    t.datetime "audio_updated_at"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "remote_audio_url"
    t.string "remote_image_url"
    t.index ["key_id"], name: "index_question_questions_items_on_key_id"
    t.index ["question_question_id"], name: "index_question_questions_items_on_question_question_id"
    t.index ["word_id"], name: "index_question_questions_items_on_word_id"
  end

  create_table "question_subtypes", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "slug"
    t.jsonb "info", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_question_subtypes_on_slug"
  end

  create_table "question_titles", force: :cascade do |t|
    t.bigint "question_question_id", null: false
    t.integer "type", default: 0
    t.string "text", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "audio_file_name"
    t.string "audio_content_type"
    t.bigint "audio_file_size"
    t.datetime "audio_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_question_id"], name: "index_question_titles_on_question_question_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "slug"
    t.jsonb "info", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_question_types_on_slug"
  end

  create_table "theme_audiences", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.bigint "cover_file_size"
    t.datetime "cover_updated_at"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "order", default: 0
  end

  create_table "themes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.string "description"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.bigint "cover_file_size"
    t.datetime "cover_updated_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_audience", default: 0, null: false
    t.integer "order", default: 0
    t.bigint "modulo_id"
    t.string "remote_cover_url"
    t.integer "status", default: 0
    t.bigint "theme_audience_id"
    t.index ["modulo_id"], name: "index_themes_on_modulo_id"
    t.index ["slug"], name: "index_themes_on_slug"
    t.index ["theme_audience_id"], name: "index_themes_on_theme_audience_id"
    t.index ["user_id"], name: "index_themes_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "theme_id", null: false
    t.string "title"
    t.string "description"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.bigint "cover_file_size"
    t.datetime "cover_updated_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0
    t.string "remote_cover_url"
    t.integer "status", default: 0
    t.index ["slug"], name: "index_units_on_slug"
    t.index ["theme_id"], name: "index_units_on_theme_id"
    t.index ["user_id"], name: "index_units_on_user_id"
  end

  create_table "user_games", force: :cascade do |t|
    t.string "unique_session_id", null: false
    t.string "name", null: false
    t.jsonb "game", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "code"
    t.index ["user_id"], name: "index_user_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthdate"
    t.string "mother"
    t.string "state"
    t.string "city"
    t.string "school_name"
    t.integer "school_year"
    t.integer "school_period"
    t.string "school_group_code"
    t.string "school_student_code"
    t.string "cpf"
    t.string "rg"
    t.integer "gender"
    t.string "school_degree_level"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "word_audios", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remote_url"
    t.index ["word_id"], name: "index_word_audios_on_word_id"
  end

  create_table "word_elements", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "element_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_word_elements_on_element_id"
    t.index ["word_id"], name: "index_word_elements_on_word_id"
  end

  create_table "word_images", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remote_url"
    t.index ["word_id"], name: "index_word_images_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "type"
    t.string "text", null: false
    t.jsonb "info", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text"], name: "index_words_on_text"
    t.index ["type"], name: "index_words_on_type"
    t.index ["user_id"], name: "index_words_on_user_id"
  end

  add_foreign_key "book_pages", "books"
  add_foreign_key "books", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "groups_participants", "groups"
  add_foreign_key "groups_participants", "users"
  add_foreign_key "karaoke_images", "karaokes"
  add_foreign_key "question_pointings", "question_questions"
  add_foreign_key "question_questions", "question_question_templates"
  add_foreign_key "question_questions", "question_subtypes"
  add_foreign_key "question_questions", "question_types"
  add_foreign_key "question_questions", "units"
  add_foreign_key "question_questions", "users"
  add_foreign_key "question_questions_descriptions", "question_descriptions"
  add_foreign_key "question_questions_descriptions", "question_questions"
  add_foreign_key "question_questions_groups", "groups"
  add_foreign_key "question_questions_groups", "question_questions"
  add_foreign_key "question_questions_item_templates", "question_item_templates"
  add_foreign_key "question_questions_item_templates", "question_questions"
  add_foreign_key "question_questions_items", "question_questions"
  add_foreign_key "question_questions_items", "question_questions_items", column: "key_id"
  add_foreign_key "question_questions_items", "words"
  add_foreign_key "question_titles", "question_questions"
  add_foreign_key "themes", "users"
  add_foreign_key "units", "themes"
  add_foreign_key "units", "users"
  add_foreign_key "user_games", "users"
  add_foreign_key "word_audios", "words"
  add_foreign_key "word_elements", "words"
  add_foreign_key "word_elements", "words", column: "element_id"
  add_foreign_key "word_images", "words"
  add_foreign_key "words", "users"
end
