$bunnyConnection = Bunny.new(:host => ENV['RABBITMQ_HOST'])
$bunnyConnection.start

$chatQueueName = 'pendingChats'
$messageQueueName = 'pendingMessages'
