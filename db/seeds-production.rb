require 'csv'
require 'erb'
require 'json'

AMBIENTE = ENV.fetch('LUZ_DO_SABER_AMBIENTE', 'fundamental') # fundamental ou eja

puts '====================================='
puts "      [aplicacao] #{AMBIENTE}"
puts '====================================='

puts '[add] Admin'

admin = User.admin.where(email: 'admin@mail.com').first_or_initialize
admin.update first_name: 'Admin', last_name: 'Admin', password: '123456'

puts '[crud] Módulos'

modulos_file = Rails.root.join('db', 'seeds', AMBIENTE, 'modulos', 'modulos.json')

if modulos_file.exist?
  modulos = ActiveSupport::JSON.decode File.read modulos_file
  modulos.each do |modulo|
    m = Modulo.where(title: modulo['name']).first_or_initialize
    m.type = modulo['type'] if modulo['type'].present?
    m.order = modulo['order']
    m.save

    modulo['themes'].each do |theme|
      ta = Theme.target_audiences[theme['target_audience']] || 0
      theme_cover = theme['image'].present? ? [ENV['ASSET_HOST'], theme['image']].join('/') : nil

      t = m.themes.create user: admin,
                         title: theme['name'],
                         order: Theme.next_order,
               target_audience: ta,
              remote_cover_url: theme_cover

      theme['units'].present? && theme['units'].each_with_index do |unit|
        unit_cover = unit['image'].present? ? [ENV['ASSET_HOST'], unit['image']].join('/') : nil

        t.units.create user: admin,
                      title: unit['name'],
                      order: unit['order'],
           remote_cover_url: unit_cover
      end
    end
  end
end

puts '[crud] Palavras'

words_txt = File.read Rails.root.join('db', 'seeds', 'palavras.csv')
words = CSV.parse words_txt, headers: true, encoding: 'ISO-8859-1'

words.each do |row|
  next unless row['word'].present?
  next if Word.where(text: row['word'].split('-').join).any?

  puts " -- #{row['word']}"

  w = Word.substantivo_comum.new user: admin,
                  elements_attributes: row['word'].split('-').map { |s| { type: :silaba, text: s } }

  w.save!
end

# Problema com palavras compostas:
Word.substantivo_comum.where("text ~ 'PEGA VARETAS'").update_all text: 'PEGA-VARETAS'
Word.substantivo_comum.where("text ~ 'CABRA CEGA'").update_all text: 'CABRA-CEGA'
Word.substantivo_comum.where("text ~ 'PEGA PEGA'").update_all text: 'PEGA-PEGA'
Word.substantivo_comum.where("text ~ 'PIQUE ESCONDE'").update_all text: 'PIQUE-ESCONDE'
Word.substantivo_comum.where("text ~ 'VAGA LUME'").update_all text: 'VAGA-LUME'

# https://www.dicionariodenomesproprios.com.br/nomes-femininos/
puts '[crud] Nomes'

names_txt = File.read Rails.root.join('db', 'seeds', 'pessoas.csv')
names = CSV.parse names_txt, headers: true, encoding: 'ISO-8859-1'

names.each do |row|
  # next if Word.where(text: row['word'].split('-').join).any?

  w = Word.substantivo_proprio.new user: admin,
                                 gender: row['gender'],
                    elements_attributes: row['word'].split('-').map { |s| { type: :silaba, text: s } }

  w.save!
end

puts '[crud] Numeros'

numbers_txt = File.read Rails.root.join('db', 'seeds', 'numeros.csv')
words = CSV.parse numbers_txt, headers: true, encoding: 'ISO-8859-1'

words.each do |row|
  next if Word.where(text: row['word'].split('-').join).any?

  w = Word.numero.new user: admin, text: row['word']
  w.save
end

puts '[crud] Caracteres especiais'

words_txt = File.read Rails.root.join('db', 'seeds', 'caracteres.csv')
words = CSV.parse words_txt, headers: true, encoding: 'ISO-8859-1', quote_char: '|'

words.each do |row|
  w = Word.caractere_especial.new user: admin, text: row['word']
  w.save
end

puts '[crud] Tipos de atividade'

types_txt = File.read Rails.root.join('db', 'seeds', 'question_types.csv')
question_types = CSV.parse types_txt, headers: true, encoding: 'ISO-8859-1'

question_types.each do |row|
  Question::Type.create title: row['type']
end

puts '[crud] Subtipos de atividade'

types_txt = File.read Rails.root.join('db', 'seeds', 'question_subtypes.csv')
question_subtypes = CSV.parse types_txt, headers: true, encoding: 'ISO-8859-1'

question_subtypes.each do |row|
  Question::Subtype.create title: row['subtype']
end

puts '[crud] Componentes'

templates_txt = File.read Rails.root.join('db', 'seeds', 'item_templates.csv')
item_templates = CSV.parse templates_txt, headers: true, encoding: 'ISO-8859-1'

item_templates.each do |row|
  Question::ItemTemplate.create name: row['name'], type: row['name'].split(' ').last.downcase.gsub('á','a').gsub('í', 'i').to_sym
end

puts '[audios] Titulo das atividades'

audio_folder = 'public/audios/enunciados'
Dir.glob("#{audio_folder}/*.mp3").each do |f|
  new_name = [File.basename(f).to_s.gsub('.mp3', '').parameterize, '.mp3'].join
  new_file = [audio_folder, new_name].join('/')

  File.rename f, new_file
end

puts '[templates] Template de atividade'

Dir.glob("db/seeds/templates/**/*.erb").sort.each do |template|
  puts "#{template.gsub('db/seeds/templates/', ' - ')}\n"

  # Primeiro deve fazer o parse do ERB, depois do JSON
  template = JSON.parse ERB.new(File.read(template)).result
  template['user'] = User.admin.first

  # Cria template
  Question::QuestionTemplate.create template
end

puts '[crud] Atividades'

Dir.glob("db/seeds/#{AMBIENTE}/modulos/**/*.erb").sort.each do |atividade|
  puts "#{atividade.gsub('db/seeds/', ' - ')}\n"

  # Primeiro deve fazer o parse do ERB, depois do JSON
  questao = JSON.parse ERB.new(File.read(atividade)).result
  questao['user'] ||= admin

  # Cria a atividade
  q = Question::Question.new questao
  q.save!
end

puts '[crud] Livros'

books_file = Rails.root.join('db', 'seeds', AMBIENTE, 'books.csv')

if books_file.exist?
  books_txt = File.read books_file
  books = CSV.parse books_txt, headers: true, encoding: 'ISO-8859-1'

  books.each do |row|
    puts "#{row['title']}\n"
    Book.create user: admin,
               order: row['order'],
               title: row['title'],
             authors: row['authors'],
         total_pages: row['pages']
  end
end
