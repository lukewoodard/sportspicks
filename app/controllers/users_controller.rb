class UsersController < ApplicationController
  before_filter :authenticate, :only => [:picks]
  before_filter :correct_user, :only => [:picks]
  def new
    @user = User.new
    @title = "sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to selectsports_path
    else 
      render 'users/new'
    end
  end
  
  def selectsports
    @title = "select your sports"
  end
  
  def picks
    @title = "your picks"
  end
  
  def index
    render :action => :new
  end

  private

   def authenticate
     deny_access unless signed_in?
   end

   def correct_user
     @user = User.find(session[:id])
     redirect_to(root_path) unless current_user?(@user)
   end
end
