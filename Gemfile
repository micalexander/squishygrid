# If you have OpenSSL installed, we recommend updating
# the following line to use "https"
source 'http://rubygems.org'

# gem "rack-livereload", :group   => :development
gem 'sinatra',         :require => 'sinatra/base'
gem 'sinatra-param'
gem 'sinatra-support', :require => 'sinatra/support'
gem 'sinatra-asset-pipeline'
gem 'sinatra-contrib'
gem 'sinatra-partial'
gem 'puma'
# gem 'mina-puma', :git => 'https://github.com/growthrepublic/mina-puma.git', :require => false

# Adds Slim support for rapid development
gem "slim", "~> 2.1.0"

# Import entire sass folders
gem 'sass-globbing', '~> 1.1.0'
gem 'shotgun'
gem 'tilt', '~> 1.4.1'
gem 'rdoc-rouge', :git => 'https://github.com/snievas/rdoc-rouge.git'
gem 'rouge', "~> 1.3"
gem 'glorify'
gem 'compass'
gem 'json'

# For faster file watcher updates:
# gem "wdm", "~> 0.1.0") # Windows

# Cross-templating language block fix for Ruby 1.8
platforms :mri_18 do
  gem "ruby18_source_location"
end
