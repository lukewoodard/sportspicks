module SessionsHelper
  def signed_in?
    !current_user.nil?
  end
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
    session[:id] = nil
    session[:current_user] = nil
  end
  
  def current_user=(user)
    session[:id] = user.id
    session[:current_user] = user
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page"
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def current_user?(user)
    user.id == current_user.id
  end
  
  private
  
  def user_from_remember_token
    session[:current_user] || User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
end
