class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  has_many :flags, as: :flaggable

  validate :sender_not_flagged

  def sender_not_flagged
    self.sender.flagged_messages.each do |flagged_message|
      if flagged_message.flagger_id == self.receiver_id
        errors.add(:blocked, "We couldn't send this message")
      end
    end
  end
end
