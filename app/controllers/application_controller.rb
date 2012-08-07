class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def authenticate_user!
    reset_session unless session[:last_page_load].present? && session[:last_page_load] > 1.day.ago
    session[:last_page_load] = Time.now
    unless logged_in?
      session[:redirect_url] = request.url
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def redirect_back_or_default(default, options = {})
    redirect_to((session[:redirect_url] ? session[:redirect_url] : default), options)
    session[:redirect_url] = nil
  end


  def get_new_question
    count = 0
    uid = current_user.try(:id) || 0
    begin
      question = Question.random
      vote = Vote.where("user_id = ? AND question_id = ?", uid, question.id).first
      count += 1
    end while count < 40 && (question.user_id == uid || vote.present?)
    if count < 40
      question
    else
      nil
    end
  end



end
