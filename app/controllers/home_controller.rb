class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing_page, :desktop]

  def index
    @nearby_sparks = current_user.relevant_sparks
    @nearby_sparks = WillPaginate::Collection.create(params[:page] || 1, 1, @nearby_sparks.length) do |pager|
      pager.replace @nearby_sparks
    end
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
