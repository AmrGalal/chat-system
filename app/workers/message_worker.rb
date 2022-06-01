class MessageWorker
    include Sneakers::Worker
    from_queue $messageQueueName

    def work(msg)
        jsonMessage = JSON.parse(msg)
        Message.create(chat_id: jsonMessage['chat_id'],number: jsonMessage['message_number'],content: jsonMessage['content'])
        ack!
    end
end