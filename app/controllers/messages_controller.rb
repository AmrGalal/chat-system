class MessagesController < ApplicationController
  before_action :set_chat_id, :set_message_number

  # GET /messages
  def index
    @messages = Message.where(chat_id: @chat_id)

    render json: @messages.as_json(:except => [:id, :chat_id])
  end

  # POST /messages
  def create
    @message = Message.new(content: params[:content], chat_id: @chat_id, number: @message_number)

    if @message.save
      render json: @message.as_json(:except => [:id, :chat_id]), status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_id
      application_id = Application.where(token: params[:application_id]).ids[0]
      @chat_id = Chat.where(application_id: application_id, number: params[:chat_id]).ids[0]
      puts @chat_id
    end

    def set_message_number
      @message = Message.where(chat_id: @chat_id).last
      if @message == nil
        @message_number = 1
      else
        @message_number = @message.number + 1
      end
    end
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:chat_id, :content)
    end
end
