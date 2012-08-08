class QuestionsController < InheritedResources::Base
  actions :new, :index, :create, :show

  before_filter :authenticate_user!, only: [:new, :create, :show]

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

  def next
    @question = get_new_question
    if @question.present?
      answers = @question.answers.each.map { |a| { :answer => a.answer, :id => a.id, :votes => (a.votes_count.to_i > 0 ? a.votes_count : 0) }  }
      render :json => { :question => { :question => @question.question, :slug => @question.slug, :answers => answers } }
    else
      render :json => { :question => false }
    end
  end

  def show
    @question = Question.find(params[:id])
    @already_voted = @question.already_voted(current_user)
  end


end
