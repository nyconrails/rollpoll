class PagesController < ApplicationController

  def index
    @question = Question.random
  end

end
