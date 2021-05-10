FactoryBot.define do
  factory :karaoke_image do
    karaoke { nil }
    image { "" }
    order { 1 }
  end

  factory :karaoke do
    title { "MyString" }
    status { "MyString" }
    lyrics { "" }
  end

  factory :question_questions_group do
    question_question { nil }
    group { nil }
    status { 1 }
  end

  factory :user_game do
    unique_session_id { "MyString" }
    name { "MyString" }
    game { "MyString" }
  end

  factory :question_questions_description, class: 'Question::QuestionsDescription' do
    question_question { nil }
    question_description { nil }
  end

  factory :question_question_template, class: 'Question::QuestionTemplate' do
    type { 1 }
    name { "MyString" }
    image { "" }
    question_type { "MyString" }
    question_subtype { "MyString" }
    question_total_correct_items { 1 }
    question_shuffle_keys { false }
    question_shuffle_values { false }
    points_lost_a_star_by_attempt { 1 }
    points_lost_a_star_by_time { 1 }
    item_template_key_font_size { "MyString" }
    item_template_key_custom { "MyString" }
    item_template_key_tags { "MyString" }
    item_template_key_total_per_line { 1 }
    item_template_key_question_item_template_id { 1 }
    item_template_value_font_size { "MyString" }
    item_template_value_custom { "MyString" }
    item_template_value_tags { "MyString" }
    item_template_value_total_per_line { 1 }
    item_template_value_question_item_template_id { 1 }
  end

  factory :book do
    user { nil }
    slug { "MyString" }
    title { "MyString" }
    subtitle { "MyString" }
    total_pages { 1 }
    authors { "" }
    cover_remote_url { "MyString" }
    cover { "" }
    pdf_remote_url { "MyString" }
    pdf { "" }
    zip_pages { "" }
    status { 1 }
  end

  factory :question_pointing, class: 'Question::Pointing' do
    question { nil }
    type { 1 }
    quantity { 1 }
    description { "MyString" }
  end
  factory :modulo do
    title { "MyString" }
    description { "MyString" }
    slug { "MyString" }
    status { 1 }
    image { "" }
    info { "" }
  end
  factory :question_questions_item, class: 'Question::QuestionsItem' do
    question_question { nil }
    word { nil }
    type { 1 }
    key_id { 1 }
    info { "" }
  end
  factory :question_questions_item_template, class: 'Question::QuestionsItemTemplate' do
    question_question { nil }
    question_item_template { nil }
    type { 1 }
    tags { "" }
    info { "" }
  end
  factory :question_description, class: 'Question::Description' do
    question { nil }
    type { 1 }
    text { "MyString" }
    image { "" }
    audio { "" }
  end
  factory :question_title, class: 'Question::Title' do
    question { nil }
    type { 1 }
    text { "MyString" }
    image { "" }
    audio { "" }
  end
  factory :question_question, class: 'Question::Question' do
    user { nil }
    unity { nil }
    question_type { nil }
    order { 1 }
    description { "MyString" }
    total_correct_items { 1 }
    info { "" }
  end
  factory :question_item_template, class: 'Question::ItemTemplate' do
    type { 1 }
    total_per_line { 1 }
    image { "" }
  end
  factory :question_type, class: 'Question::Type' do
    title { "MyString" }
    description { "MyString" }
    info { "" }
  end
  factory :word_audio do
    word { nil }
    attachment { "" }
  end
  factory :word_image do
    word { nil }
    attachment { "" }
  end
  factory :word_element do
    word { nil }
    element { nil }
  end
  factory :word do
    user { nil }
    type { 1 }
    text { "MyString" }
    info { "" }
  end
  factory :groups_participant do
    type { 1 }
    user { nil }
    group { nil }
    status { 1 }
  end
  factory :group do
    user { nil }
    name { "MyString" }
    description { "MyString" }
  end
  factory :unit do
    user { nil }
    theme { nil }
    title { "MyString" }
    description { "MyString" }
    cover { "" }
  end
  factory :theme do
    user { nil }
    title { "MyString" }
    description { "MyString" }
    cover { "" }
  end
  factory :user do
    
  end
end
