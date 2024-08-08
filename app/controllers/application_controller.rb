class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = AuthenticationService.decode_token(token)
    if decoded_token
      @current_user = User.find_by(email: decoded_token['email'])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
