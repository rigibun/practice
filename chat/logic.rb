require_relative 'model'

$chat = Chat.new
$rooms = [Room.new('test')]
$rooms[0].post '太郎', 'こんにちは'
