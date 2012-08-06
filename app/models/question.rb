class Question < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  has_many :answers

  attr_accessible :question, :answers_attributes
  accepts_nested_attributes_for :answers


  extend FriendlyId
  friendly_id :question, use: :slugged

  validates :question, presence: true
  validate :valid_answers
  before_create :clean_answers



  private
    def valid_answers
      count = 0
      answers.each do |a|
        count += 1 unless a.answer.blank?
      end
      errors.add(:answers, "Please add at least 2 answers.") if count < 2
    end

    def clean_answers
      answers.each do |a|
        a.destroy if a.answer.blank?
      end
    end

end
