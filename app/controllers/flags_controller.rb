class FlagsController < ApplicationController
  def create
    @flag = Flag.new(reason: params[:flag][:reason],
      flagger_id: current_user.id,
      flaggable_type: params[:flag][:flaggable_type])

    @conversation_partner = User.find(params[:flag][:sender_id])
    @last_message = Message.where('sender_id = ? and receiver_id = ?', @conversation_partner.id, current_user.id)[-1]

    @flag.update_attribute(:flaggable_id, @last_message.id)

    binding.pry
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
