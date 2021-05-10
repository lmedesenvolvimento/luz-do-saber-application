#Pry.config.prompt = proc do |obj, level, _|
#  prompt = "\e[1;30m"
#  prompt << "#{Rails.version}@" if defined?(Rails)
#  prompt << "#{RUBY_VERSION}"
#  "#{prompt} (#{obj})>\e[0m"
#end
#
#Pry.config.exception_handler = proc do |output, exception, _|
#  output.puts "\e[31m#{exception.class}: #{exception.message}"
#  output.puts "from #{exception.backtrace.first}\e[0m"
#end

require "awesome_print"
AwesomePrint.pry!
