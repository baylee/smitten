class UsersController < ApplicationController
  def show
    @message_partners = []

    current_user.sent_messages.each do |message|
      @message_partners << message.receiver
    end

    current_user.received_messages.each do |message|
      @message_partners << message.sender
    end

    @message_partners = @message_partners.uniq{ |partner| partner }
  end
end
