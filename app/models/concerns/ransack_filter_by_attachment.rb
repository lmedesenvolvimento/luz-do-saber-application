# frozen_string_literal: true

require 'active_support/concern'

module RansackFilterByAttachment
  extend ActiveSupport::Concern

  included do
    ransacker :image_exists do |parent|
      Arel.sql("(SELECT EXISTS (SELECT 1 FROM word_images WHERE word_images.word_id = words.id))")
    end

    ransacker :audio_exists do |parent|
      Arel.sql("(SELECT EXISTS (SELECT 1 FROM word_audios WHERE word_audios.word_id = words.id))")
    end
  end
end
