require 'sinatra'
require 'sinatra/reloader'
require 'haml'

require './src/main.rb'

run Sinatra::Application
