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
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :sparks


  # NOT NEEDED WHEN WE ARE ONLY ADDING USERS THROUGH FB
  #
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

	def password_required?
	  super && services.first.provider.blank?
	end

	def update_with_password(params, *options)
	  if encrypted_password.blank?
	    update_attributes(params, *options)
	  else
	    super
	  end
	end

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

  def all_messages(conversation_partner)
    @messages = []
    sent_messages = self.sent_messages.where('receiver_id = ?', conversation_partner.id)
    received_messages = self.received_messages.where('sender_id = ?', conversation_partner.id)

    @messages << sent_messages
    @messages << received_messages
    @messages.flatten!

    @messages = @messages.sort {
      |a,b| b.created_at <=> a.created_at
    }

    @messages
  end

end
