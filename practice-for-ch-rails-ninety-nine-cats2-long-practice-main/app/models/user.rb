class User < ApplicationRecord
    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: self.username)
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


end
