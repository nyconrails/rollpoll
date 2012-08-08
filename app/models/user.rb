class User < ActiveRecord::Base

  has_secure_password

  has_many :questions
  has_many :votes

  attr_accessible :dob, :email, :gender, :password_digest, :zip, :password, :password_confirmation, :username

  # validates :username, :email, :password, :password_confirmation, :zip, :gender, :dob, presence: true
  validates :username, :email, presence: true
  validates :username, :uniqueness => true
  validates :email, email: true

  validates :password, :password_confirmation, presence: true, :if => :is_new_record
  validates :password, :confirmation => true, :if => :is_new_record



  private
    def is_new_record
      new_record?
    end

end
