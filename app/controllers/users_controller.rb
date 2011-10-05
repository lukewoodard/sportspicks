require 'stripe'

class UsersController < ApplicationController
  before_filter :authenticate, :only => [:picks, :selectsports, :selectsportscreate, :charge, :chargecreate]
  before_filter :correct_user, :only => [:picks, :selectsports, :selectsportscreate, :charge, :chargecreate]
  
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
    @sports = Sport.find(:all)
    @user = current_user
  end
  
  def picks
    @title = "your picks"
  end
  
  def index
    render :action => :new
  end
  
  def show
    @title = "select your sports"
    @sports = Sport.find(:all)
    @user = current_user
    render :action => :selectsports
  end
  
  def selectsportscreate
    @user = current_user

    @user.user_transactions = Array.new
    userTransaction = @user.user_transactions.build(:total => 0, :transaction_date => Date.today)
   
    params.each do |key, value|
      if(key.to_s[/sport.*/])
        id = key.tr("sport", "")
        weeks = params["weeks" + id].to_i
        userTransaction.user_transaction_items.build(:sport_id => id, :weeks => weeks)
        userTransaction.total += weeks * 9
        
        @user.user_sports.build(:sport_id => id, :expiration_date => Date.today.advance(:weeks => weeks))
      end
    end
    
    if(userTransaction.total == 0)
      flash.now[:error] = "Please select a sport to purchase"
      @title = "select your sports"
      @sports = Sport.find(:all)
      render :action => :selectsports
    else
      session[:current_user] = @user
      redirect_to charge_path
    end
  rescue => e
    @title = "select your sports"
    @errorMessage = "An error occurred saving the selection: " + e.message
    render :action => :selectsports
  end
  
  def charge
    @user = current_user
    @appsettings = Settings.find(:all)
    @title = "credit card information"
  end
  
  def chargecreate
    token = params[:stripeToken]
    @appsettings = Settings.find(:all)
    @user = current_user
    
    Stripe.api_key = @appsettings.select{|s| s.key == "stripe_sec_key" }.first.value
    charge = Stripe::Charge.create(
      :amount => @user.user_transactions[0].total.to_i * 100,
      :currency => "usd", 
      :card => token,
      :description => @user.email
    )
    
    if !@user.save
      raise "unable to save user information"
    end
    
    redirect_to success_path
  rescue => e
    @title = "credit card information"
    @errorMessage = "An error occurred processing payment: " + e.message
    render :action => :charge
  end
  
  def success
    @title = "success"
    @user = current_user
  end

  private

   def authenticate
     deny_access unless signed_in?
   end

   def correct_user
     if(session[:id] == nil && session[:current_user] == nil)
         redirect_to(root_path)
     else
       @user = session[:current_user] || User.find(session[:id])
       redirect_to(root_path) unless current_user?(@user)
     end
   end
end
