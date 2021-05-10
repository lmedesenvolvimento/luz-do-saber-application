import { WordTypes } from '../types'

export default class Word {
  type = WordTypes.substantivo_comum.value
  text = ''
  images_attributes = [] // :_destroy, :id, :attachment, :remote_url
  audios_attributes = []  // :destroy, :id, :attachment, :remote_url
}