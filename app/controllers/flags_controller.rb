class FlagsController < ApplicationController
  def create
    @flag = Flag.new(reason: params[:flag][:reason],
      flagger_id: current_user.id,
      flaggable_type: params[:flag][:flaggable_type],
      flaggable_id: params[:flag][:flaggable_id])

    respond_to do |format|
      if @flag.save
        format.html { redirect_to messages_path, notice: 'Content was flagged'}
        format.js
      else
        format.html { redirect_to messages_path, :alert => 'Flag failed to save.' }
        format.js
      end
    end
  end
end
