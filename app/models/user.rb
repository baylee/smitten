class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :services, :dependent => :destroy
  has_many :messages, foreign_key: 'sender_id'
  has_many :messages, foreign_key: 'receiver_id'
  has_many :sparks


	# def self.from_omniauth(auth)
	#   where(auth.slice(:provider, :uid)).first_or_create do |user|
	#     user.provider = auth.provider
	#     user.uid = auth.uid
	#     user.username = auth.info.nickname
	#   end
	# end

	# def self.new_with_session(params, session)
	#   if session["devise.user_attributes"]
	#     new(session["devise.user_attributes"], without_protection: true) do |user|
	#       user.attributes = params
	#       user.valid?
	#     end
	#   else
	#     super
	#   end
	# end

	# def password_required?
	#   super && provider.blank?
	# end

	# def update_with_password(params, *options)
	#   if encrypted_password.blank?
	#     update_attributes(params, *options)
	#   else
	#     super
	#   end
	# end

  def facebook
    @facebook ||= Koala::Facebook::API.new(services.first.oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end
end
