class Admin::QuestionsController < Admin::ApplicationController
  inherit_resources

  def index
    @questions = Question.includes(:user).order("created_at desc")
  end


end
