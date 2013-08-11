class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    locations_latlong = []
    sparks_near_time = []
    @nearby_sparks = []

    # For each post on FB, if there is a location attached, then put the lat and lon of
    # that location into an array, and push that array into locations_latlong
    current_user.facebook.get_connection("me", "feed").each do |fb_post|
      if !fb_post["place"].nil?
        locations_latlong << [fb_post["place"]["location"]["latitude"], fb_post["place"]["location"]["longitude"], Time.zone.parse(fb_post["created_time"])]
      end
    end

    # Also push the location of the user's sparks into the locations_latlong array
    # locations_latlong now holds all the locations a user has been
    current_user.sparks.each do |spark|
      locations_latlong << [spark.latitude, spark.longitude, spark.created_at]
    end

    # Find sparks within a time range around each location_latlong object
    locations_latlong.each do |location|
      sparks_near_time << Spark.where('created_at between ? and ?', location[2] - 3600, location[2] + 3600)
    end

    # For each location in location_latlong, find the nearby sparks
    sparks_near_time.each do |y|
      @nearby_sparks << Spark.near([y[0],y[1]], 0.5)
    end

    binding.pry
    # This gets rid of any nearby spark searches that returned nothing
    @nearby_sparks.flatten!
    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    @nearby_sparks = @nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }
  end
end
