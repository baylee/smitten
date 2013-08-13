class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:landing_page, :desktop]

  def index
    @nearby_sparks = current_user.relevant_sparks

    # will_paginate is designed to work on models; this allows it to work on an array
    current_page = params[:page] || 1
    per_page = 20
    @nearby_sparks = WillPaginate::Collection.create(current_page, per_page, @nearby_sparks.length) do |pager|
      pager.replace @nearby_sparks[pager.offset, pager.per_page].to_a
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
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
