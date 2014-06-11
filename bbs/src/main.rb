require './src/utils.rb'
require './src/logic.rb'

initApp()

get '/' do
  haml :index
end

get '/create' do
  haml :create
end

get '/list' do
  @list = getTopicList
  haml :list
end

get %r{/show/([0-9]+)$} do |id|
  id = id.to_i
  topic = getTopic(id)
  if topic
    @title = topic.title
    @responses = topic.responses
    haml :show
  else
    redirect "/404"
  end
end

post '/create' do
  createTopic(params["title"], params["name"], params["text"])
  redirect '/list'
end

post '/response' do
  name, text, id = params["name"], params["text"], params["id"].to_i
  topic = getTopic(id)
  if topic
    topic.addResponse(name, text)
    redirect "/show/#{id}"
  else
    redirect "/404"
  end
end
