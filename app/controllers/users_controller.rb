class UsersController < InheritedResources::Base
  actions :new, :index, :create, :show

  skip_before_filter :authenticate_user!

  def username_check
    user = User.where("username = ?", params[:uname]).first
    if user.present?
      render :json => { free: false }
    else
      render :json => { free: true }
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      session[:last_page_load] = Time.now
      flash[:success] = "Your account has been created successfully."
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def show
    authenticate_user!
  end

  def history
    authenticate_user!
    @questions_asked = Question.where(:user_id => current_user.id).order("created_at desc")
    user_votes = Vote.where(:user_id => current_user.id).map(&:question_id)
    @questions_answered = Question.find(user_votes).sort_by(&:created_at).reverse
  end

end
