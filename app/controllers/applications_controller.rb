class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show update ]
  before_action :set_application_token, only: %i[ create ]

  # GET /applications
  def index
    @applications = Application.all.as_json(:except => :id)
    render json: @applications
  end

  # GET /applications/1
  def show
    render json: @application.as_json(:except => :id)
  end

  # POST /applications
  def create
    @application = Application.new(token: @applicationToken, name: params[:name])
    
    if @application.save
      render json: @application.as_json(:except => :id), status: :created, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application.update(application_params)
      render json: @application.as_json(:except => :id)
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.where(token: params[:id]).last
    end

    def set_application_token
      # Generate a random token of length 8 upon the creation of a new application
      token_length = 8
      while true
        @applicationToken = rand(36**10).to_s(36)
        results = Application.where(token: @applicationToken)
        if results.length == 0
          break
        end 
      end
    end

    # Only allow a list of trusted parameters through.
    # Permit only the name field to be passed by FE
    def application_params
      params.require(:application).permit(:name)
    end
end
