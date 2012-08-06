class User < ActiveRecord::Base

  has_secure_password

  has_many :questions
  has_many :votes

  attr_accessible :dob, :email, :gender, :password_digest, :zip, :password, :password_confirmation





end
