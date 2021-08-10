# config.ru
require 'sinatra'

set :environment, ENV['RACK_ENV'] || 'development'

require './application' #  File.absolute_path('server.rb')
run Sinatra::Application

