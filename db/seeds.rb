SEEDS_ENV = ENV.fetch('SEEDS_ENV', 'production')

puts '====================================='
puts "      [ENV] #{SEEDS_ENV}"
puts '====================================='

load File.join(Rails.root, 'db', "seeds-#{SEEDS_ENV}.rb")
