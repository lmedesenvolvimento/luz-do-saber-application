# Helpers dos itens das atividades.
module Game::QuestionItemHelper
  # Item KEY.
  #
  # Cada item KEY indica os itens VALUES associados.
  def item_key_set_value_ids(key_item)
    case @question.questions_item_templates.key.last.custom
    when 'app-helper-item-substantivo-ultima-letra' then custom_item_substantivo_ultima_letra(key_item)
    when 'app-helper-item-substantivo-vogais'       then custom_item_substantivo_vogais(key_item)
    when 'app-helper-item-substantivo-consoantes'   then custom_item_substantivo_consoantes(key_item)
    else; complete_value_ids_for_this_item_key(key_item)
    end
  end

  # Item VALUE.
  #
  # Cada item VALUE possui um key_id associado (se form um item marcado como correto).
  def item_value_set_key_id(value_item)
    case @question.questions_item_templates.value.last.custom
    when 'app-helper-vogais'
      value_item.key_id if value_item.word.is_vowel
    else
      value_item.key_id
    end
  end

  private

  # Os itens podem se repetir.
  # Ex.: Um parametro externo ANA tem dois itens repetidos.
  #      E isso deve ser refletido nos itens para que a atividade nao diferencie o A do inicio com o A do final,
  #      pois pra atividade eh apenas um A.
  #
  # Se uma chave se repetir o values_ids dos itens devem contemplar esses VALUE.
  def complete_value_ids_for_this_item_key(key_item)
    # Itens VALUE que possuem a mesma key_id.
    value_ids_with_same_key_id = @question.items.value.where(key_id: key_item.id).pluck(:id)

    # Item VALUE relacionado diretamente ao item KEY (key_item).
    item_value_for_this_key_item = @values.select { |v| v.id == value_ids_with_same_key_id.first }.first

    return unless item_value_for_this_key_item

    # O restante dos itens VALUE da atividade.
    other_item_values = @values.select { |v| v.id != item_value_for_this_key_item.id }

    # Itens com o mesmo tipo e texto.
    other_item_values_for_this_key_item = other_item_values.select do |ov|
                                            # Outros itens com o mesmo tipo
                                            ov.word.type === item_value_for_this_key_item.word.type &&
                                              # e o mesmo texto.
                                              ov.word.text == item_value_for_this_key_item.word.text
                                          end.map(&:id)

    # Todos os itens VALUE que devem ser relacionados ao key_item indicado.
    value_ids_with_same_key_id +
      other_item_values_for_this_key_item
  end

  def custom_item_substantivo_ultima_letra(key_item)
    @question.items.value.where(key_id: key_item.id).pluck(:id) if key_item.id == @keys.last.id
  end

  def custom_item_substantivo_vogais(key_item)
    @question.items.value.where(key_id: key_item.id).pluck(:id) if key_item.word.is_vowel
  end

  def custom_item_substantivo_consoantes(key_item)
    @question.items.value.where(key_id: key_item.id).pluck(:id) if key_item.word.is_consonant
  end
end
