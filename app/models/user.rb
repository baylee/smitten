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

  def received_message_from_partner?(conversation_partner)
    x = false
    self.received_messages.each do |message|
      if message.sender_id == conversation_partner.id
        x = true
      end
    end
    x
  end

  def anonymized_name(conversation_partner)
    if self.received_message_from_partner?(conversation_partner)
      conversation_partner.email
    else
      'Anonymous'
    end
  end

  def relevant_sparks
    locations_latlong = []
    sparks_near_time = []
    nearby_sparks = []

    # For each post on FB, if there is a location attached, then put the lat and lon of
    # that location into an array, and push that array into locations_latlong
    self.facebook.get_connection("me", "feed").each do |fb_post|
      if !fb_post["place"].nil?
        locations_latlong << [fb_post["place"]["location"]["latitude"], fb_post["place"]["location"]["longitude"], Time.zone.parse(fb_post["created_time"])]
      end
    end

    # Also push the location of the user's sparks into the locations_latlong array
    # locations_latlong now holds all the locations a user has been
    self.sparks.each do |spark|
      locations_latlong << [spark.latitude, spark.longitude, spark.created_at]
    end

    # Find sparks within a time range around each location_latlong object
    locations_latlong.each do |location|
      sparks_near_time << Spark.where('created_at between ? and ?', location[2] - 3600, location[2] + 3600)
    end

    # For each location in location_latlong, find the nearby sparks
    sparks_near_time.flatten!
    sparks_near_time.each do |spark|
      nearby_sparks << Spark.near([spark.latitude, spark.longitude], 0.5)
    end

    # This gets rid of any nearby spark searches that returned nothing
    nearby_sparks.flatten!
  end

end
