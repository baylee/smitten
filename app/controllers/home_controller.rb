class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing_page]

  def index
    @nearby_sparks = current_user.relevant_sparks
  end

  def landing_page
  end

  def desktop
  end
end
