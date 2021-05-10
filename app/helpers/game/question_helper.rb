# Helpers das atividades.
module Game::QuestionHelper
  # Total de itens corretos na atividade.
  # Algumas atividades, principalmente as que recebem parametro externo, variam a quantidade de itens corretos.
  # Se um item for custom, a quantidade de itens tambem pode ser diferente.
  def calculate_total_correct_items
    case @question.questions_item_templates.key.last.custom
    when 'app-helper-item-substantivo-vogais'         then @keys.select { |v| v.word.is_vowel }.length
    when 'app-helper-item-substantivo-consoantes'     then @keys.select { |v| v.word.is_consonant }.length
    when 'app-helper-items-corretos-considerar-key'   then @keys.length
    else
      # 99 indica que o total eh variavel.
      # Assim, o total sera a soma de todos os itens KEY preenchidos.
      # return @keys.length if @question.total_correct_items == 99
      return @values.select { |v| v.key_id.in?(@keys.pluck(:id)) }.length if @question.total_correct_items == 99

      # Do contrario usa a indicacao da questao.
      @question.total_correct_items
    end
  end
end
