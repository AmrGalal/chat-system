class ChatsController < ApplicationController
  before_action :set_application_id, :set_chat_number, only: %i[ create ]

  # POST /chats
  def create
    @chat = Chat.new(application_id: @application_id, number: @chat_number)

    if @chat.save
      render json: @chat.as_json(:except => :id), status: :created, location: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_id
      @application_id = Application.where(token: params[:application_id])
      @application_id = @application_id.ids[0]
      puts @application_id
    end

    def set_chat_number
      @chat = Chat.where(application_id: @application_id).last
      if @chat == nil
        @chat_number = 1
      else
        @chat_number = @chat.id + 1
      end
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:application_id, :number)
    end
end
