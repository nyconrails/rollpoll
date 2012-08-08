class Administrator < ActiveRecord::Base

  has_secure_password

  attr_accessible :name, :username, :password, :password_confirmation

  validates :username, uniqueness: true
  validates :name, :username, :password, :password_confirmation, presence: true

end
