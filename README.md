## Luz do Saber

[Instalação no CentOs](https://bitbucket.org/lmedesenvolvimento/luz-do-saber/src/master/docs/INSTALACAO-CENTOS.md)

[API](https://bitbucket.org/lmedesenvolvimento/luz-do-saber/src/master/docs/API.md)


## TAGS

Aplicado à ação realizada no componente.
Indica como o usuário vai interagir com o componente.

    arrastar
    encaixar
    selecao
    ligacao
    input
    upload

## Itens: Modificadores

O item possui um atributo modificador chamado __word_source_type__.
Esse atributo informa pra atividade como ela deve gerar cada item.

Por exemplo, um item pode ser setado como sendo um valor externo, como sendo o mesmo valor da chave ou um valor diferente, etc.

```ruby

                          random: 1, # Valor aleatorio.

                        key_same: 2, # Mesmo valor da chave.
                   key_different: 3, # Nao deve comecar com a mesma letra.

                  # Variacoes do valor recebido por parametro.

                  external_param: 4, # Parametro recebido pela atividade.
        external_param_different: 5, # Nao deve comecar com a mesma letra.
        external_param_variation: 6, # Muda as letras da palavra de input.
          external_param_similar: 7, # Deve comecar com a mesma letra ou silaba.
     external_param_similar_male: 8, # Deve comecar com a mesma letra mas do genero masculino.
   external_param_similar_female: 9, # Deve comecar com a mesma letra mas do genero feminino.

                    input_custom: 10, # Sem definicao do usuario. Pode ser uma frase, um texto longo, uma img, etc.

```

## CUSTOM: Itens customizados

Quando um item recebe um valor no custom esse valor indica que os itens, KEY ou VALUE, recebem um tratamento diferente.

Itens customizados para o Jogo recebem um prefixo __game-__ enquanto os itens customizados no servidor recebem um prefixo __app-__ ou __app-helper-__.

### Para o Jogo

O template do item indica o custom.

    game-caixa-de-palavras
    game-grupo-de-palavras
    game-fonte-alternada
    game-cracha-box
    game-display-18-items
    game-texto-em-blocos
    game-card-display-com-validacao
    game-checkmark

### Para o sistema

O prefixo __app-helper__ informa que o item vai receber um segundo tratamento antes de exibir os valores para os jogos.

Isso é necessário pois algumas atividades, que recebem parâmetros externos, só definem os itens corretos quando todos os itens estão preenchidos.

    app-item-substantivo-para-item-letra
    app-item-substantivo-para-item-silaba

    app-helper-item-substantivo-ultima-letra
    app-helper-item-substantivo-consoantes
    app-helper-item-substantivo-vogais

    app-item-substantivo-total-letras
    app-item-substantivo-primeira-letra

    game-display-18-items

## Heroku [cleanup]

    git push origin master && \
      git push staging master && \
      heroku pg:reset DATABASE --confirm luz-do-saber-staging && \
      heroku run rails db:migrate db:seed
