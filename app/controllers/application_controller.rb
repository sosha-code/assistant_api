class ApplicationController < ActionController::API
  rescue_from JWT::ExpiredSignature, with: :handle_expired_signature_error
  rescue_from JWT::DecodeError, with: :handle_decode_error

	attr_reader :current_user
  
	private

	def authenticate_user!
    token = request.headers["Authorization"]&.split(" ").last
    payload = JsonWebToken.decode(token)
    sub = payload&.dig(:sub)

    @current_user = User.find_by(id: sub) if sub
    return if @current_user

	  render json: { error: "Unauthorized"}, status: :unauthorized 
  end

  def handle_expired_signature_error(error)
  	render json: { error: error.message }, status: :unauthorized
  end  
  def handle_decode_error(error)
  	render json: { error: error.message }, status: :unauthorized
  end
end
