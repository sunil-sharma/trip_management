class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def generate_jwt
    AuthenticationService.encode_token({ email: email })
  end
end
