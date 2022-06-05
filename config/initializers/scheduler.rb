require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '30m' do
    Application.all.each do |application|
        application.chat_count = application.chats.count
        application.save
    end

    Chat.all.each do |chat|
        chat.messages_count = chat.messages.count
        chat.save
    end
  end