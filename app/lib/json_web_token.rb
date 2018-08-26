# this singleton provides a wrapper for JWT

class JsonWebToken
  HMAC_SECRET = TodosApi::Application.credentials.secret_key_base

  def self.encode(payload, exp = 30.seconds.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload, first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
    # rescue from all decode errors
  rescue JWT::DecodeError => error
    raise ExceptionHandler::InvalidToken, error.message
  end
end