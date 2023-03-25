class UsersController < ApplicationController

    before_action :authorize, only: [:show]

    def create
        user = User.new(user_params)
        if user.valid? && params[:password] == params[:password_confirmation]
          user.save!
          session[:user_id] = user.id
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

    def show
        user = User.find(session[:user_id])
        if user
            render json: user
        else
            render json: {error: "user not authorized"}, status: :unauthorized
        end
    end

    private

    def authorize
        render json: {error: "user not authorized"}, status: :unauthorized unless session.include? :user_id
    end 

    def user_params
        params.permit(:username, :bio, :image_url, :password, :password_digest, :password_confirmation)
    end
end
