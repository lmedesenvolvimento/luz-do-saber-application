source 'https://rubygems.org'

ruby '2.5.1'

# git_source(:github) do |repo_name|
#   repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
#   'https://github.com/#{repo_name}.git'
# end

gem 'rails', '~> 5.2.0'
gem 'rack-cors', require: 'rack/cors'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'execjs'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'therubyracer'
gem 'sass-rails'
# [start] A deletar
gem 'bourbon', '~> 5.0'
gem 'sprockets', '>= 3.0.0'
# [end] A deletar

gem 'title'
gem 'slim-rails'
gem 'simple_form'
gem 'select2-rails'
gem 'cocoon'
gem 'delayed_job_active_record'

# gem 'neat', '~> 2.1' # grid system

gem 'webpacker'

gem 'pg'
gem 'puma'

gem 'paperclip'
gem 'friendly_id'
gem 'rubyzip'

gem 'devise'
gem 'pundit'
gem 'enum_help'
gem 'will_paginate'
gem 'ransack'
gem 'jbuilder'

# gem 'honeybadger'
gem 'rack-canonical-host'
gem 'recipient_interceptor'
gem 'bootsnap', require: false
gem 'high_voltage'

# gem 'skylight'
gem 'uglifier'

gem 'dotenv-rails'

gem "aws-sdk-s3", require: false

gem 'open-uri', require: false
gem 'mini_magick', require: false

group :production do
  gem 'rack-timeout'
end

group :development do
  gem 'foreman'
  gem 'rack-mini-profiler', require: false
  gem 'listen'
  gem 'spring'
  gem 'web-console'
  gem 'spring-commands-rspec'

  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-npm'
  gem 'capistrano-dotenv', require: false
  gem 'capistrano3-delayed-job'
end

group :development, :test do
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'awesome_print'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.6'
  gem 'suspenders'
  gem 'bullet'
  gem 'factory_bot_rails'
end

group :test do
  gem 'simplecov', require: false
  gem 'formulaic'
  gem 'launchy'
  gem 'timecop'
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
end
