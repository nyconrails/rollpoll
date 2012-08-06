class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @question = Question.random
  end

end
