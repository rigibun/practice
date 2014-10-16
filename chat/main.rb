require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'
require 'sass'

require_relative 'logic'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure do
    #use Rack::Session::Cookie
    enable :sessions
  end

  get '/' do
    @styleSheets = ["index"]
    haml :index
  end

  get '/room/:number' do
    redirect 'join' unless (p session[:username])
    @room = $rooms[params[:number].to_i]
    @name = session[:username]
    haml :room
  end

  get '/join' do
    if session[:username]
      @errorFlag = !!session[:join_error]
      redirect '/rooms'
    else
      @styleSheets = ["join"]
      haml :join
    end
  end

  post '/join' do
    if $chat.join(params["username"])
      session[:username] = params["username"]

      redirect '/rooms'
    else
      session[:join_error] = true
      redirect '/join'
    end
  end

  get '/rooms' do
    redirect '/join' unless session[:username]
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
