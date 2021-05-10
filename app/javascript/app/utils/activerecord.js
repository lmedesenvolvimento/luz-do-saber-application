import { each } from 'lodash'

export default {
  errorMessage: (errors) => {
    const messages = []
    
    each(errors, (msg, key) => {
      messages.push(`${key} - ${msg}`)
    })

    return messages
  }
}