source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.13'
gem "twitter-bootstrap-rails"
gem "sinatra"
gem "sinatra-contrib", require: false
gem 'pusher'
gem 'mqtt'
gem 'mail'
gem 'twitter'
gem 'twitter_oauth'
gem 'exception_notifier'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'devise'
gem 'figaro'
gem 'mongoid'
group :development do
#  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19]
  gem 'quiet_assets'
  gem 'rails_layout'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'thin'
  gem 'pry'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
#  gem 'rvm1-capistrano3', require: false
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
  gem 'mongoid-rspec'
end
