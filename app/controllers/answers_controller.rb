class AnswersController < InheritedResources::Base
  actions :show

  def vote
    answer = Answer.find(params[:id])
    if answer
      answers = answer.question.answers.map(&:id)
      already_voted = Vote.find :all, :conditions => ["answer_id in (?) and user_id = ?", answers, current_user.id]
      answer.votes.create(:user_id => current_user.id) if already_voted.blank?
    end
    redirect_to root_path
  end

end
