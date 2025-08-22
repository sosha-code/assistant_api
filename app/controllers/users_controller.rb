class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]

	def create
		user = User.new(user_params)
		if user.save
			token = JsonWebToken.encode({ sub: user.id , exp: 24.hours.from_now.to_i })
      render json: { user: { id: user.id, email: user.email}, token: token}, status: :created
		else
			render json: { errors: user.errors }, status: :unprocessable_entity
		end
	end

	def show
		render json: { user: {id: current_user.id, name: current_user.name, email: current_user.email }}, status: :ok
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
