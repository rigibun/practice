require 'json'
require './src/utils.rb'

def initApp
  $AppDir = Dir::pwd
  $Config = openJSON('config.json')
  $DataPath = $Config["dataPath"] || ($AppDir + '/data')
  $TopicsPath = $Config["TopicPath"] || ($DataPath + '/topics')
  $counter = getMaxTopicNum + 1
  $topics = {}
end

def openJSON fileName, dirName = ($AppDir + '/data')
  begin
    file = File.open(dirName + '/' + fileName)
    json = JSON.parse(file.read)
  rescue => ex
    p ex
  end
  if json
    json
  else
    {}
  end
end

class Topic
  def initialize(topicID)
    @fileName = $TopicsPath + '/' + topicID.to_s
    file = File.open(@fileName)
    @title = file.gets.chomp
    @responses = []
    until file.eof?
      name, text = file.gets.chomp.split('<>')
      @responses.push [name, text]
    end
    file.close
  end

  def addResponse(name, text)
    name = CGI.escapeHTML(name)
    text = escapeText(text)
    @fileName
    file = File.open(@fileName, "a")
    file.puts(name + '<>' + text)
    file.close
    @responses.push [name, text]
  end

  attr_reader :title, :responses
end

def getMaxTopicNum
  Dir::chdir($TopicsPath)
  files = Dir::glob("*").select{|s| /^[0-9]+$/ =~ s}.map{|s| s.to_i}.sort_by{|i| -i}
  if files.size <= 0
    0
  else
    files.first
  end
end

def getTopic(topicID)
  if $topics.key?(topicID)
    $topics[topicID]
  else
    topic = nil
    begin
      topic = Topic.new(topicID)
    rescue => ex
      p ex
    end
    topic
  end
end

def getTopicList
  files = Dir.glob($TopicsPath + '/*').sort_by{|f| File.mtime(f)}.reverse.map{|s| File.basename(s).to_i}
  list = []
  files.each do |id|
    topic = getTopic(id)
    list.push [id, topic]
  end
  list
end

def createTopic(title, name, text)
  title = CGI.escapeHTML(title)
  name = CGI.escapeHTML(name)
  text = escapeText(text)

  topicID = $counter
  fileName = $TopicsPath + '/' + topicID.to_s
  $counter += 1

  file = File.open(fileName, "w")
  file.puts(title, name + '<>' + text)
  file.close

  $topics[topicID] = Topic.new(topicID)
end
