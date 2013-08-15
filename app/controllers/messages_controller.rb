class MessagesController < ApplicationController

  def index
    @message_partners = []

    current_user.sent_messages.each do |message|
      @message_partners << message.receiver
    end

    current_user.received_messages.each do |message|
      @message_partners << message.sender
    end

    @message_partners = @message_partners.uniq{ |partner| partner }

    # Takes nil values out of the array
    @message_partners.compact!
  end

  def show
    @message = Message.new
    @conversation_partner = User.find(params[:partner_id])

    @messages = current_user.all_messages(@conversation_partner)

    respond_to do |format|
      format.html
      format.js
    end
  end
  def refresh
    @message = Message.new
    @conversation_partner = User.find(params[:partner_id])

    @messages = current_user.all_messages(@conversation_partner)
  end
  def create
    @message = current_user.sent_messages.build(params[:message])

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
