class JsonWebToken
	ISSUER = "assistant_api"

  def self.secret_key
	  ENV["JWT_SECRET"].presence ||  Rails.application.credentials.secret_key_base
  end

	def self.encode(payload, exp: 24.hours.from_now.to_i)
		data = payload.dup
		data[:exp] ||= exp
		data[:iss] ||= ISSUER

		JWT.encode(data, secret_key, "HS256")
	end

	def self.decode(token)
		return nil if token.blank?

		body, = JWT.decode(token, secret_key, true, { algorithm: "HS256", iss: ISSUER, verify_iss: true })
		HashWithIndifferentAccess.new(body)
	rescue JWT::ExpiredSignature
	  raise
	rescue JWT::DecodeError
		raise
	end  

end