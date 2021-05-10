export default class Item {
  constructor(type, word_type, word_text, remote_image_url, value_items_attributes = null, word_source_type = null){
    this.type = type
    this.word_type = word_type
    this.text = word_text // for ls-select-multiple
    this.word_text = word_text
    this.remote_image_url = remote_image_url

    if (value_items_attributes) {
      this.value_items_attributes = value_items_attributes
    }

    if (word_source_type) {
      this.word_source_type = word_source_type
    }
  }
}
