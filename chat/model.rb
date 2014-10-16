require 'json'

class Chat
  def initialize
    @users = []
  end

  def join username
    unless @users.find{|name| name == username}
      @users.push username
      true
    else
      false
    end
  end
end

class Room
  def initialize title
    @title = title
    @posts = []
    @nextId = 1
  end

  def get id = 0
    @posts[id .. -1]
  end

  def getJson id = 0
    JSON.generate self.get id
  end

  def post user, message
    @posts.push({user: user, message: message, time: Time.now})
    @nextId += 1
  end

  attr_reader :title
end
