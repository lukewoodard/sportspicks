class User < ActiveRecord::Base
  has_many :user_picks, :dependent => :destroy
  has_many :user_transactions, :dependent => :destroy
  has_many :user_transaction_items, :through => :user_transactions
  has_many :picks, :through => :user_picks
  
  has_many :user_sports, :dependent => :destroy
  has_many :sports, :through => :user_sports
  
  attr_accessor :password, :password_confirmation
  attr_accessible :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :length => { :within => 6..40 }, :if => :password_validation_required?
  validates :password, :confirmation => true
  
  before_save :encrypt_password
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2::hexdigest(string)
  end
  
  def password_validation_required?
    encrypted_password.blank?
  end
end
