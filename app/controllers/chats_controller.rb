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

    chatObject = {
      application_id: @application_id,
      chat_number: @chat_number
    }
    handler = PublishHandler.new
    handler.send_message($chatQueueName, chatObject)
    render :json => {"number": @chat_number}, status: :created
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_id
      @application_id = Application.where(token: params[:application_id]).ids[0]
    end

    def set_chat_number
      redis_key = "chat_number_for_" + @application_id.to_s
      redis_handler = RedisHandler.new
      @chat_number = redis_handler.incr_key(redis_key)
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:application_id, :number)
    end
end
