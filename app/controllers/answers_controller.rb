class AnswersController < InheritedResources::Base
  actions :show

  before_filter :authenticate_user!

  def vote
    answer = Answer.find(params[:id])
    if answer
      # answers = answer.question.answers.map(&:id)
      # already_voted = Vote.find :all, :conditions => ["answer_id in (?) and user_id = ?", answers, current_user.id]
      already_voted = Vote.where("user_id = ? AND question_id = ?", current_user.id, answer.question.id).first
      answer.votes.create(:user_id => current_user.id, question_id: answer.question.id) if already_voted.blank?
    end
    redirect_to root_path
  end

end
