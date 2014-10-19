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
    redirect '/join' unless session[:username] # ログインしていない場合joinにリダイレクト
    @roomNumber = params[:number].to_i
    @room = $rooms[@roomNumber]
    @name = session[:username]
    unless session[:joined].split.find{|s| s == params[:number]}
      session[:joined] += " #{params[:number]}"
      @room.join @name
    end
    @styleSheets = ["room"]
    haml :room
  end

  get '/api/get_json' do
    room = $rooms[params[:room_number].to_i]
    id = if params[:id]
              params[:id].to_i
            else
              0
            end
    room.getJson(id)
  end

  post '/api/send_json', provides: :json do
    p params = JSON.parse(request.body.read)
    room = $rooms[params["nubmer"].to_i]
    name = params["name"]
    text = params["text"]
    room.post name, text
    'test'
  end

  get '/join' do
    if session[:username] # ログインしている場合
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
      session[:joined] = ""
      redirect '/rooms'
    else # 既にusernameが存在する場合
      session[:join_error] = true
      redirect '/join'
    end
  end

  get '/rooms' do
    redirect '/join' unless session[:username] # ログインしていない場合joinにリダイレクト
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
