class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
    skip_before_action :check_user, only: [:create]

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: {error: "Not logged in"}, status: 404
        end
    end

    #signup
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end 

    private
    #error handling 
    def render_invalid_record(invalid)
        render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def user_params
        params.permit(:username, :password)
    end
end
