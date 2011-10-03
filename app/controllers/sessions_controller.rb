class SessionsController < ApplicationController
  def new
    @title = "sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password"
      render :action => :new
    else
      sign_in user
      redirect_back_or picks_path
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def index
    render :action => :new
  end

end
