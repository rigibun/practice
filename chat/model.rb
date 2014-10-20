require 'json'

class Chat
  def initialize
    @users = []
    @rooms = []
  end

  def join username
    unless @users.find{|name| name == username}
      @users.push username
      true
    else
      false
    end
  end

  def createRoom title
    @rooms.push Room.new(title)
  end

  attr_accessor :rooms
end

class Room
  def initialize title
    @title = title
    @posts = []
    @nextId = 1
  end

  def get id = -1
    ret = []
    cnt = 0
    @posts.reverse_each do |post|
      break if cnt > 20 or post[:id] == id
      cnt += 1
      ret.push post
    end
    ret
  end

  def getJson id = -1
    JSON.generate({id: @nextId - 1, messages: self.get(id)})
  end

  def post user, message
    @posts.push({id: @nextId, type: "message", user: user, message: message, time: Time.now.strftime("%Y-%m-%d %H:%M:%S")})
    @nextId += 1
  end

  def join user
    @posts.push({id: @nextId, type: "join", user: user, message: "#{user} さんが参加しました!", time: Time.now.strftime("%Y-%m-%d %H:%M:%S")})
    @nextId += 1
  end

  attr_reader :title, :nextId
end
