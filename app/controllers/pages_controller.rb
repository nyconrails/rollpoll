class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @question = get_new_question
    if @question.nil?
      redirect_to ninja_questions_path
    end
  end

end
