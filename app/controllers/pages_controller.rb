class PagesController < ApplicationController


  def index
    if logged_in?
      @question = Question.not_voted_on(current_user, session[:last_q_shown].presence).random
      session[:last_q_shown] = @question.id if @question.present?
      redirect_to ninja_questions_path if @question.nil?
    else
      @question = Question.avoid(session[:last_q_shown].presence).random
      session[:last_q_shown] = @question.id if @question.present?
    end
  end

end
