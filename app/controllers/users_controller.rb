class UsersController < ApplicationController
  def index

  end

  def show
    user_sparks = Spark.where(:user_id => current_user.id)

    @user_sparks = user_sparks.sort {
      |a,b| b.created_at <=> a.created_at
    }

  end
end
