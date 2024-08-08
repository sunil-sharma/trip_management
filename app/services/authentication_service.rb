require 'jwt'

class AuthenticationService
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode_token(payload)
    JWT.encode(payload, HMAC_SECRET, 'HS256')
  end

  def self.decode_token(token)
    JWT.decode(token, HMAC_SECRET, true, { algorithm: 'HS256' })[0]
  rescue JWT::DecodeError
    nil
  end
end
