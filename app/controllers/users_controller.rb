class UsersController < InheritedResources::Base
  actions :new, :index, :create, :show

  skip_before_filter :authenticate_user!

  def username_check
    user = User.where("username = ?", params[:uname])
    if user.present?
      render :json => { free: false }
    else
      render :json => { free: true }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        session[:last_page_load] = Time.now
        flash[:success] = "Your account has been created successfully."
        redirect_to root_path
      else
        render :action => "new"
      end
    end
  end

  def show
    authenticate_user!
  end

end
