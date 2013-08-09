class MessagesController < ApplicationController
  def show
    @message = Message.new
    @conversation_partner = User.find(params[:partner_id])

    @messages = current_user.all_messages(@conversation_partner)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # def new
  #   @message = Message.new
  #   @conversation_partner = User.find(params[:partner_id])

  #   respond_to do |format|
  #     format.html
  #     format.js
  #   end
  # end

  def create
    @message = current_user.sent_messages.create(params[:message])

    respond_to do |format|
      if @message.save
        @conversation_partner = User.find(params[:message][:receiver_id])
        @messages = current_user.all_messages(@conversation_partner)
        format.html { redirect_to message_path(@message.receiver_id), notice: 'Message has been sent'}
        format.js
      else
        format.html { render action: 'show', notice: 'Message failed to send' }
        format.js
      end
    end
  end
end
