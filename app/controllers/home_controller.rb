class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @nearby_sparks = current_user.relevant_sparks
    # Since sparks may have been added more than once (e.g., if you were close to the same
    # spark twice), we filter for unique
    @nearby_sparks = @nearby_sparks.uniq.sort {
      |a,b| b.created_at <=> a.updated_at
    }
  end
end
