class MessagesController < ApplicationController
  def show
    @message = Message.new
    @conversation_partner = User.find(params[:partner_id])

    @messages = []
    sent_messages = current_user.sent_messages.where('receiver_id = ?', @conversation_partner.id)
    received_messages = current_user.received_messages.where('sender_id = ?', @conversation_partner.id)

    @messsages << sent_messages
    @messages << received_messages
    @messages.flatten!

    @messages = @messages.sort {
      |a,b| b.created_at <=> a.created_at
    }

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
  end

  def create
  end
end
