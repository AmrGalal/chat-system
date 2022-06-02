class ChatsController < ApplicationController
  before_action :set_application_id
  before_action :set_chat_number, only: %i[ create ]

  # GET /chats
  def index
    @chats = Chat.where(application_id: @application_id).all.as_json(:except => [:id, :application_id])
    render json: @chats
  end

  # POST /chats
  def create

    channel = $bunnyConnection.create_channel
    chatQueue = channel.queue($chatQueueName, durable: true)
    chatObject = {
      application_id: @application_id,
      chat_number: @chat_number
    }
    chatQueue.publish(chatObject.to_json, routing_key: chatQueue.name)
    render :json => {"chat_number": @chat_number}, status: :created
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_id
      @application_id = Application.where(token: params[:application_id]).ids[0]
    end

    def set_chat_number
      redis_key = "chat_number_for_" + @application_id.to_s
      $redis.watch(redis_key)
      @chat_number = $redis.incr(redis_key)
      $redis.unwatch()
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:application_id, :number)
    end
end
