class UsersController < ApplicationController
  def index

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
