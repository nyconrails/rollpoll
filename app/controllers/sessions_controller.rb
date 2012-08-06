class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.where(:username => params[:session][:email]).first
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_back_or_default root_path
    else
      flash[:error].now = "Invalid login credentials."
      render action: :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end

end