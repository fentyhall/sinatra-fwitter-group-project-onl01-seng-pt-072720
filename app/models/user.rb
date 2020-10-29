class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug 
    self.name.downcase.split.join("-")
  end 
end
