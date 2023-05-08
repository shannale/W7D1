

class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true


    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return user if user && user.is_password(password)
        nil 
    end

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end 

    def is_password?(password)
        BCrypt::Password.new(password_digest).is_password?(password)
    end 

    def reset_session_token!
        self.session_token ||= SecureRandom::url_safe_base64
        self.save!
        self.session_token
    end

    private
    def generate_unique_session_token
        loop do 
        session_token = SecureRandom::url_safe_base64
        return session_token unless User.exists?(session_token: session_token)
        end
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::url_safe_base64
    end
end
