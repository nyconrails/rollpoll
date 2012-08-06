class QuestionsController < InheritedResources::Base
  actions :new, :index, :create, :show

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.create(params[:question])

    if @question.save
      flash[:success] = 'Your question has been created and is now being shown to other users.'
      redirect_to question_path(@question)
    else
      render :action => "new"
    end
  end


end
