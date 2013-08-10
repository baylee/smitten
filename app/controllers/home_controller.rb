class HomeController < ApplicationController
  def index
    onlylocation_posts = []
    @nearsparks = []
    current_user.facebook.get_connection("me", "feed").each do |x|
      if !x["place"].nil?
        onlylocation_posts << x
      end
    end
    onlylocation_posts.each do |y|
     @nearsparks << Spark.near([y["place"]["location"]["latitude"], y["place"]["location"]["longitude"]], 0.5)
     # binding.pry
    end
  end
end
