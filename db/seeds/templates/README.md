Para adicionar o novo template ao DB (abrir o rails console e executar):

```ruby
Dir.glob("db/seeds/templates/comecar/*.erb").sort.each do |template|
  puts "#{template.gsub('db/seeds/templates/', ' - ')}\n"

  # Primeiro deve fazer o parse do ERB, depois do JSON
  template = JSON.parse ERB.new(File.read(template)).result
  template['user'] = User.admin.first

  # Cria template
  Question::QuestionTemplate.create template
end
```
