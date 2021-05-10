## Game API

### Staging URL

    https://luz-do-saber-staging.herokuapp.com

### Lista toda a estrutura do Game

    GET http://<HOST>/game/all

    { slug: 'comecar', themes: [{ slug: 'meu-nome', units: [{ slug: 'meu-nome', questions: [{ order: 1, ...
    { slug: 'ler', themes: [{ slug: 'associacao', units: [{ slug: 'marque-as-palavras', questions: [{ order: 1, ...
    { slug: 'escrever', themes: [{ slug: 'escrever', units: [{ slug: 'meu-nome', questions: [{ order: 1, ...

### Lista de módulos

    GET http://<HOST>/game

    [{
      id: 1,
      slug: "comecar",
      title: "Começar",
      description: null,
      order: 1,
      themes_url: "/game/comecar"
    }, {...}]

### Lista de temas de um módulo

    GET http://<HOST>/game/<:MODULO_SLUG>

    [{
      target_audience: "general",
      modulo_id: 1,
      id: 1,
      slug: "meu-nome",
      title: "Meu Nome",
      description: null,
      order: 1,
      units_url: "/game/comecar/meu-nome",
      cover_url: null
    }, {...}]

### Lista de unidades de um tema

    GET http://<HOST>/game/<MODULO_SLUG>/<THEME_SLUG>

    [{
      id: 1,
      theme_id: 1,
      slug: "meu-nome",
      title: "Meu Nome",
      description: null,
      order: 1,
      questions_url: "/game/comecar/meu-nome/meu-nome",
      cover_url: null
    }, {...}]

### Lista todas as atividades de uma unidade

    GET http://<HOST>/game/<MODULO_SLUG>/<THEME_SLUG>/<UNIT_SLUG>

    [question1, question2, ...]

### Lista uma questão de uma unidade

  Algumas atividades recebem parâmetros externos, como as atividades que pedem o nome do usuário.

    GET http://<HOST>/game/<MODULO_SLUG>/<THEME_SLUG>/<UNIT_SLUG>/<QUESTION_ORDER>?external_params[0][name]=NOME_1&external_params[0][name]=NOME_2&...

    {
      "id": 1,
      "order": 1,
      "module_id": 1,
      "theme_id": 1,
      "unit_id": 1,
      "module": {"id": 1, "slug": "comecar", "title": "Começar", "order": 1},
      "theme": {"id": 1, "slug": "meu-nome", "title": "Meu Nome", "order": 1},
      "unit": {"id": 1, "slug": "meu-nome", "title": "Meu Nome", "order": 1},
      "type": {"id": 1, "title": "Atividade - Texto", "slug": "atividade-texto"},
      "subtype": {"id": 1, "title": "Padrão", "slug": "padrao"},
      "total_correct_items": 1,
      "pointings": [
        { "type": "lost_a_star_by_attempt", "quantity": 2 },
        { "type": "lost_a_star_by_time", "quantity": 30 }],
      "title": {"type": "texto", "text": "CRACHÁ", "image": null, "audio": null},
      "statement": {"type": "texto", "text": "ENCONTRE O CRACHÁ QUE TEM SEU NOME", "image": null, "audio": null},
      "item_template": {
        "key": {
          "font_size": "relative",
          "total_per_line": 0,
          "custom": null,
          "tags": null
        },
        "value": {
          "type": "texto",
          "name": "Componente de Texto",
          "slug": "componente-de-texto",
          "font_size": "relative",
          "total_per_line": 3,
          "custom": "game-cracha-box",
          "tags": "selecao"
        }},
      "items": {
        "keys": [
          {
            "value_ids": [2],
            "id": 1,
            "type": "substantivo_proprio",
            "text": "DAMIS",
            "gender": null,
            "first_letter": "D",
            "last_letter": "S",
            "total_letters": 5
          }],
        "values": [
          {
            "key_id": 1,
            "id": 2,
            "type": "substantivo_proprio",
            "text": "DAMIS",
            "gender": null,
            "first_letter": "D",
            "last_letter": "S",
            "total_letters": 5
          },
          {
            "id": 3,
            "type": "substantivo_proprio",
            "text": "DAVI",
            "gender": "m",
            "first_letter": "D",
            "last_letter": "I",
            "total_letters": 4
          },
          {
            "id": 4,
            "type": "substantivo_proprio",
            "text": "DÉBORA",
            "gender": "f",
            "first_letter": "D",
            "last_letter": "A",
            "total_letters": 6
          },
          {
            "id": 7,
            "type": "substantivo_proprio",
            "text": "RAQUEL",
            "gender": "f",
            "first_letter": "R",
            "last_letter": "L",
            "total_letters": 6
          },
          {
            "id": 6,
            "type": "substantivo_proprio",
            "text": "ZILDA",
            "gender": "f",
            "first_letter": "Z",
            "last_letter": "A",
            "total_letters": 5
          },
          {
            "id": 5,
            "type": "substantivo_proprio",
            "text": "XIMENES",
            "gender": "m",
            "first_letter": "X",
            "last_letter": "S",
            "total_letters": 7
          }]}}

### Parâmetros de uma atividade

    GET http://<QUESTAO_URL>?external_params[0][name]=damis&external_params[0][photo]=IMAGE_URL&external_params[1][name]=wedson&external_params[1][photo]=IMAGE_URL&external_params[2][name]=julianne&external_params[2][photo]=IMAGE_URL&external_params[3][name]=davi&external_params[3][photo]=IMAGE_URL

    external_params[0][name]=NOME_1
    external_params[0][photo]=IMAGE_URL_1

    external_params[1][name]=NOME_2
    external_params[1][photo]=IMAGE_URL_2

    external_params[2][name]=NOME_3
    external_params[2][photo]=IMAGE_URL_3

    external_params[3][name]=NOME_4
    external_params[3][photo]=IMAGE_URL_4
