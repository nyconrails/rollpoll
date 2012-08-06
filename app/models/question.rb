class Question < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  has_many :answers

  attr_accessible :question, :user_id

  extend FriendlyId
  friendly_id :question, use: :slugged


end
