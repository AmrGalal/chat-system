class ChatWorker
    include Sneakers::Worker
    from_queue $chatQueueName

    def work(msg)
        jsonMessage = JSON.parse(msg)
        Chat.create(application_id: jsonMessage['application_id'], number: jsonMessage['chat_number'])
        ack!
    end
end