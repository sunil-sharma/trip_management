module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user, only: [:create]

      # POST /api/v1/login
      def create
        user = User.find_by(email: params[:email])
        if user
          render json: { token: user.generate_jwt }, status: :ok
        else
          render json: { error: 'Invalid email' }, status: :unauthorized
        end
      end
    end
  end
end
