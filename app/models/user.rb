class User < ActiveRecord::Base

  has_secure_password

  has_many :questions
  has_many :votes

  attr_accessible :dob, :email, :gender, :password_digest, :zip, :password, :password_confirmation, :username

  validates :username, :email, :password, :password_confirmation, :zip, :gender, :dob, presence: true
  validates :username, :uniqueness => true
  validates :password, :confirmation => true
  validates :email, email: true



end
