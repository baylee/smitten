class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing_page, :desktop]

  def index
    @nearby_sparks = current_user.relevant_sparks
    @spark = Spark.new
  end

  def landing_page
    # ADD THIS BACK ONCE WE ARE READY TO START TESTING ON MOBILE ONLY!

    # if !mobile_device?
    #   redirect_to desktop_path
    # end
  end

  def desktop
  end
end
