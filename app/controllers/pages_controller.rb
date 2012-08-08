class PagesController < ApplicationController


  def index
    @question = get_new_question
    if @question.nil?
      redirect_to ninja_questions_path
    end
  end

end
