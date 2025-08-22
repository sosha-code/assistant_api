class SessionsController < ApplicationController
	def create
		user = User.find_by(email: params[:email])
		if user&.authenticate(params[:password])
			token = JsonWebToken.encode({ sub: user.id , exp: 24.hours.from_now.to_i })
      render json: { user: {id: user.id, email: user.email}, token: token }, status: :ok
		else
			render json: { error: "Invalid email or password" }, status: :unauthorized
		end
	end
end