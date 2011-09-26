class User < ActiveRecord::Base
  has_many :authentications  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  belongs_to :group
  belongs_to :location
  has_one :province, :through => :location
  has_one :country, :through => :province
  belongs_to :party
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :location_id, :party_id, :group_id

  validates_presence_of :username

  has_many :nodes
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def valid_password?(password)  
    !authentications.empty? || super(password)  
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def score_count
    @user = User.find(id,
                       :select => "users.id, users.username, users.group_id, users.location_id, SUM(scores.score) AS score",
                       :conditions => ["nodes.last_seen > '#{Date.today - 7.days}'"],
                       :joins =>  {:nodes => :scores},
                       :group => "users.id, users.username, users.group_id, users.location_id",
                       :order => 'SUM(scores.score) DESC')
    @user.score
  end
end

