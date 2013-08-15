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
  has_many :flagged_messages, through: :sent_messages, source: :flags
  has_many :flagged_sparks, through: :sparks, source: :flags
  has_many :flags, foreign_key: 'flagger_id'


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

  # Hides the password form fields if there is an omniauth provider
	def password_required?
	  super && services.first.provider.blank?
	end

	# Allows user to update their data even if they don't have a password, e.g.,
  # in the case of a user who only authenticated with omniauth
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

  # returns an array of all the messages a user has had with a given other user,
  # the conversation partner
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

  # returns true if the user has received any messages from the convo partner, false otherwise
  def received_message_from_partner?(conversation_partner)
    x = false
    self.received_messages.each do |message|
      if message.sender_id == conversation_partner.id
        x = true
      end
    end
    x
  end

  # if a user has received messages from the conversation partner, the user will see
  # convo partner's email, else they will see "anonymous"
  def anonymized_name(conversation_partner)
    if self.received_message_from_partner?(conversation_partner)
      conversation_partner.get_profile_name
    else
      'Anonymous'
    end
  end

  # returns an array of all the places a user has been, including:
  # - facebook checkins
  # - sparks with or without notes
  # - sparks with or without location_only set to true
  def places_ive_been
    locations_latlong = []
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

    locations_latlong
  end

  # COMMENTED because we are no longer showing all places you've been on map
  #
  # def places_ive_been_for_map
  #   locations_latlong = []
  #   # For each post on FB, if there is a location attached, then put the lat and lon of
  #   # that location into an array, and push that array into locations_latlong
  #   self.facebook.get_connection("me", "feed").each do |fb_post|
  #     if !fb_post["place"].nil?
  #       locations_latlong << [fb_post["place"]["location"]["latitude"], fb_post["place"]["location"]["longitude"], fb_post["place"]["name"]]
  #     end
  #   end

  #   # Also push the location of the user's sparks into the locations_latlong array
  #   # locations_latlong now holds all the locations a user has been
  #   self.sparks.each do |spark|
  #     if spark.location_only == true
  #       locations_latlong << [spark.latitude, spark.longitude, "(You were here)", spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p')]
  #     elsif !spark.title.blank?
  #       locations_latlong << [spark.latitude, spark.longitude, spark.title, spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p') ]
  #     elsif !spark.content.blank?
  #       locations_latlong << [spark.latitude, spark.longitude, spark.content, spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p')]
  #     else
  #       locations_latlong << [spark.latitude, spark.longitude, "(You dropped a pin here.)", spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p') ]
  #     end
  #   end

  #   locations_latlong
  # end

  def relevant_sparks_for_map
    locations_latlong = self.places_ive_been
    nearby_sparks = []
    sparks_for_map = []

    # Find sparks within a time range around each location_latlong object
    locations_latlong.each do |location|
      near_a_location = []
      near_a_location << Spark.near([location[0], location[1]], 0.5)
      near_a_location.flatten!
      nearby_sparks << near_a_location.select { |spark| spark.created_at >= (location[2] - 3600) && spark.created_at <= (location[2] + 3600)}
    end

    # This gets rid of any nearby spark searches that returned nothing
    nearby_sparks.flatten!

    # This gets rid of any sparks that don't have content
    nearby_sparks = nearby_sparks.select { |spark| !spark.content.blank? }

    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    nearby_sparks = nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }

    nearby_sparks.each do |spark|
      if !spark.title.blank?
        sparks_for_map << [spark.latitude, spark.longitude, spark.title, spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p'), "sparks/#{spark.id}"]
      else
        sparks_for_map << [spark.latitude, spark.longitude, spark.content, spark.created_at.advance(:hours => -7).strftime('%B %e, %Y at %l:%M %p'), "sparks/#{spark.id}"]
      end
    end

    sparks_for_map
  end


  def relevant_sparks_near_location(location)
    nearby_sparks = []
    near_a_location = []

    # get all the sparks near location
    near_a_location << Spark.near([location[0], location[1]], 0.5)
    near_a_location.flatten!

    # of those sparks near location, only select those that were created
    # within an hour (before or after) of the time that user was at location
    nearby_sparks << near_a_location.select { |spark|
      spark.created_at >= (location[2] - 3600) && spark.created_at <= (location[2] + 3600)}

    # This gets rid of any nearby spark searches that returned nothing
    nearby_sparks.flatten!

    # This excludes any sparks that were for location update purposes only
    nearby_sparks = nearby_sparks.select { |spark| spark.location_only == false }

    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    nearby_sparks = nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }
  end

  def relevant_sparks
    locations_latlong = self.places_ive_been
    nearby_sparks = []

    # Find sparks within a time range around each location_latlong object
    locations_latlong.each do |location|
      near_a_location = []
      near_a_location << Spark.near([location[0], location[1]], 0.5)
      near_a_location.flatten!
      nearby_sparks << near_a_location.select { |spark| spark.created_at >= (location[2] - 3600) && spark.created_at <= (location[2] + 3600)}
    end

    # This gets rid of any nearby spark searches that returned nothing
    nearby_sparks.flatten!

    # This gets rid of any sparks that don't have content
    nearby_sparks = nearby_sparks.select { |spark| !spark.content.blank? }

    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    nearby_sparks = nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }
  end

  def get_profile_photo_url
    self.facebook.get_picture(self.services.first.uid)
  end

  def get_profile_name
    self.facebook.get_object(self.services.first.uid)["first_name"]
  end

end
