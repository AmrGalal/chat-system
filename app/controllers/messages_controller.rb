class MessagesController < ApplicationController
  before_action :set_chat_id
  before_action :set_message_number, only: %i[ create ]

  # GET /messages
  def index
    @messages = Message.where(chat_id: @chat_id)
    render json: @messages.as_json(:except => [:id, :chat_id])
  end

  def search
    @messages = Message.partial_match(params[:content], @chat_id)
    render json: @messages.as_json(:except => [:id, :chat_id])
  end

  # POST /messages
  def create
    messageObject = {
      chat_id: @chat_id,
      message_number: @message_number,
      content: params[:content]
    }
    handler = PublishHandler.new
    handler.send_message($messageQueueName, messageObject)
    render :json => {"message_number": @message_number}, status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_id
      application_id = Application.where(token: params[:application_id]).ids[0]
      @chat_id = Chat.where(application_id: application_id, number: params[:chat_id]).ids[0]
    end

    def set_message_number
      redis_key = "message_number_for_" + @chat_id.to_s
      redis_handler = RedisHandler.new
      @message_number = redis_handler.incr_key(redis_key)
    end
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:chat_id, :content)
    end
end
