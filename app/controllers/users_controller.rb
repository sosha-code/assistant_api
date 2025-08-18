class UsersController < ApplicationController

	def create
		user = User.new(user_params)
		if user.save
      render json: { user: { id: user.id, email: user.email}, token: issue_token(user)}, status: :created
		else
			render json: { errors: user.errors }, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	def issue_token(user)
    payload = { sub: user.id, exp: 24.hours.from_now.to_i, iss: "assistant_api" }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, "HS256")
	end
end
