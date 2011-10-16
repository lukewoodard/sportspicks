require 'stripe'

class UsersController < ApplicationController
  before_filter :authenticate, :only => [:picks, :selectsports, :selectsportscreate, :charge, :chargecreate, :account, :update]
  before_filter :correct_user, :only => [:picks, :selectsports, :selectsportscreate, :charge, :chargecreate, :account, :update]

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
    @transaction = session[:transaction]
  end
  
  def picks
    @title = "your picks"
    @user = User.find(current_user.id, :include => :user_sports, :include => :sports)
    usersports = @user.user_sports.select{|s| s.expiration_date >= DateTime.now}
    @sports = Array.new
    usersports.each do |s|
      @sports.push Sport.find(s.sport_id)
    end
  end
  
  def index
    render :action => :new
  end
  
  def selectsportscreate
    @user = User.find(current_user.id)

    userTransaction = @user.user_transactions.build(:total => 0, :transaction_date => Date.today)
    sports = Array.new
    
    params.each do |key, value|
      if(key.to_s[/sport.*/])
        id = key.tr("sport", "")
        weeks = params["weeks" + id].to_i
        userTransaction.user_transaction_items.build(:sport_id => id, :weeks => weeks)
        userTransaction.total += weeks * 9
        
        userSport = UserSport.find(:all, :conditions => { :sport_id => id, :user_id => @user.id }).first
        if(userSport == nil)
          sports.push @user.user_sports.build(:sport_id => id, :expiration_date => Date.today.advance(:days => weeks*7))
        else
          if(userSport.expiration_date >= Date.today)
            userSport.expiration_date = userSport.expiration_date.advance(:days => weeks*7)
          else
            userSport.expiration_date = Date.today.advance(:days => weeks*7)
          end
          sports.push userSport
        end
      end
    end
    
    if(userTransaction.total == 0)
      flash.now[:error] = "Please select a sport to purchase"
      @title = "select your sports"
      @sports = Sport.find(:all)
      render :action => :selectsports
    else
      session[:transaction] = userTransaction
      session[:sports] = sports
      redirect_to charge_path
    end
  rescue => e
    @title = "select your sports"
    flash.now[:error] = "An error occurred saving the selection: " + e.message
    @transaction = userTransaction
    @sports = Sport.find(:all)
    render :action => :selectsports
  end
  
  def charge
    @user = current_user
    @transaction = session[:transaction]
    @sports = session[:sports]
    @appsettings = Settings.find(:all)
    @title = "credit card information"
  end
  
  def chargecreate
    token = params[:stripeToken]
    @appsettings = Settings.find(:all)
    @user = current_user
    @transaction = session[:transaction]
    @sports = session[:sports]
    
    if !@transaction.save()
      raise "unable to save user information"
    end
    
    @sports.each do |s|
      if !s.save()
        raise "unable to save user information"
      end
    end
    
    Stripe.api_key = @appsettings.select{|s| s.key == "stripe_sec_key" }.first.value
    charge = Stripe::Charge.create(
      :amount => @user.user_transactions[0].total.to_i * 100,
      :currency => "usd", 
      :card => token,
      :description => @user.email
    )
    
    session[:transaction] = nil
    session[:sports] = nil
    
    redirect_to success_path
  rescue => e
    @title = "credit card information"
    @errorMessage = "An error occurred processing payment: " + e.message
    @user.errors.full_messages.each do |msg|
      logger.debug msg
    end
    render :action => :charge
  end
  
  def success
    @title = "success"
    @user = current_user
  end
  
  def sportspicks
    sport_id = params[:sportid].to_i
    date = Date.parse(params[:date])
    
    @picks = Pick.find(:all, :conditions => { :sport_id => sport_id, :game_date => date })
    
    render :layout => false
  end
  
  def account
    @title = "your account"
    @user = User.find(current_user.id, :include => :user_sports, :include => :sports)
    @sports = @user.sports
  end
  
  def edit
    @title = "your account"
    @user = User.find(current_user.id, :include => :user_sports, :include => :sports)
    @sports = @user.sports
  end
  
  def update
    @user = User.find(current_user.id, :include => :user_sports, :include => :sports)
    @sports = @user.sports
    
    if(@user.update_attributes(params[:user]))
      flash.now[:success] = "Account Updated"
      @user.password_confirmation = nil
      render 'account'
    else
      @title = "your account"
      @user.password_confirmation = nil
      render 'account'
    end
    
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
