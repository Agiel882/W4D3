require 'bcrypt'

class User < ApplicationRecord

  before_validation :ensure_session_token

  validates :username, :session_token, :password_digest, presence: true
  validates :username, :session_token, uniqueness: true 

  has_many :cats
  has_many :requests, class_name: :CatRentalRequests
  has_many :requested_cats, through: :requests, source: :cat

  def generate_session_token
    SecureRandom::urlsafe_base64
  end 

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    
    self.save!

    self.session_token
  end 

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password) 
  end 

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end 

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end
end
