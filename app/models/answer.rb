class Answer < ActiveRecord::Base

  belongs_to :question
  has_many :votes

  attr_accessible :answer, :question_id, :user_id
end
