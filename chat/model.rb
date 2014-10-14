require 'json'

class Room
  def initialize title
    @title = title
    @users = []
    @posts = []
    @nextId = 1
  end

  def join username
    unless @users.find username
      @users.push username
      true
    else
      false
    end
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
