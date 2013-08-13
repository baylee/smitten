class FlagsController < ApplicationController
  def create
    @flag = Flag.create(reason: params[:flag][:reason],
      flagger_id: current_user.id,
      flaggable_type: params[:flag][:flaggable_type],
      flaggable_id: params[:flag][:flaggable_id])
  end
end
