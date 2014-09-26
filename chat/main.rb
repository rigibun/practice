require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'haml'
require 'sass'

require_relative 'logic'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  use Rack::Session::Cookie
  helpers Sinatra::Cookies

  get '/set' do 
    cookies[:cookie] = 'test'
  end

  get '/get' do
    puts cookies
  end

  get '/' do
    @styleSheets = ["index"]
    haml :index
  end

  get '/rooms' do
    @styleSheets = ["rooms"]
    haml :rooms
  end

  get '/about' do
    haml :about
  end

  get %r{^/(.*)\.css$} do
    sass :"style/#{params[:captures].first}"
  end
end
