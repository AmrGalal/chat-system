class MessagesController < ApplicationController
  before_action :set_chat_id, :set_message_number

  # GET /messages
  def index
    @messages = Message.where(chat_id: @chat_id)

    render json: @messages.as_json(:except => [:id, :chat_id])
  end

  # POST /messages
  def create
    channel = $bunnyConnection.create_channel
    messageQueue = channel.queue($messageQueueName, durable: true)
    messageObject = {
      chat_id: @chat_id,
      message_number: @message_number,
      content: params[:content]
    }
    messageQueue.publish(messageObject.to_json, routing_key: messageQueue.name)
    render :json => {"message_number": @message_number}, status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_id
      application_id = Application.where(token: params[:application_id]).ids[0]
      @chat_id = Chat.where(application_id: application_id, number: params[:chat_id]).ids[0]
    end

    def set_message_number
      #TODO add Redis operation
      @message_number = 1
    end
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:chat_id, :content)
    end
end
