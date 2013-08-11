class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    locations_latlong = []
    @nearby_sparks = []

    # For each post on FB, if there is a location attached, then put the lat and lon of
    # that location into an array, and push that array into locations_latlong
    current_user.facebook.get_connection("me", "feed").each do |x|
      if !x["place"].nil?
        locations_latlong << [x["place"]["location"]["latitude"], x["place"]["location"]["longitude"]]
      end
    end

    # Also push the location of the user's sparks into the locations_latlong array
    # locations_latlong now holds all the locations a user has been
    current_user.sparks.each do |z|
      locations_latlong << [z.latitude, z.longitude]
    end

    # For each location in location_latlong, find the nearby sparks
    locations_latlong.each do |y|
      @nearby_sparks << Spark.near([y[0],y[1]], 0.5)
    end

    # This gets rid of any nearby spark searches that returned nothing
    @nearby_sparks.flatten!
    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    @nearby_sparks = @nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }
  end
end
