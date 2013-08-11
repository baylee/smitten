class HomeController < ApplicationController
  def index
    locations_latlong = []
    @nearsparks = []
    if current_user
      current_user.facebook.get_connection("me", "feed").each do |x|
        if !x["place"].nil?
          locations_latlong << [x["place"]["location"]["latitude"], x["place"]["location"]["longitude"]]

        end
        current_user.sparks.each do |z|
          locations_latlong << [z.latitude, z.longitude]
        end
      end
      locations_latlong.each do |y|
        sparks_near_location = Spark.near([y[0],y[1]], 0.5)
        if !sparks_near_location.empty?
            @nearsparks << sparks_near_location
        end
      end
    end
    @nearsparks.flatten!
    @nearsparks = @nearsparks.uniq{|x| x.id}
  end

def landing_page


end
end
