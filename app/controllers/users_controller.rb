class UsersController < ApplicationController
  def index
       @nearby_sparks = current_user.relevant_sparks
        @spark = Spark.new
       # will_paginate is designed to work on models; this allows it to work on an array
       current_page = params[:page] || 1
       per_page = 20
       @nearby_sparks = WillPaginate::Collection.create(current_page, per_page, @nearby_sparks.length) do |pager|
         pager.replace @nearby_sparks[pager.offset, pager.per_page].to_a
       end
  end
  def swipe_to_dash

  end
  def show
    user_sparks = Spark.where(:user_id => current_user.id, :location_only => false)

    @user_sparks = user_sparks.sort {
      |a,b| b.created_at <=> a.created_at
    }

  end
end
