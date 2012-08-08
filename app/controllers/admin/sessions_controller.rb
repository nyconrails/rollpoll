class Admin::SessionsController < Admin::ApplicationController

  skip_before_filter :require_login!

  def new
    session[:last_page_load] = Time.now
  end

  def create
    admin = Administrator.find_by_username(params[:session][:username])
    if admin && admin.authenticate(params[:session][:password])
      session[:admin_id] = admin.id
      session[:last_page_load] = Time.now
      redirect_to admin_root_url, notice: "Logged in!"
    else
      flash.now.alert = "Invalid login credentials."
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path
  end


end
