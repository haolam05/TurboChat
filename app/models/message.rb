class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit do
    update_parent_room
    broadcast_append_to self.room 
  end

  before_create :confirm_participant

  def confirm_participant
    return unless room.is_private

    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end

  # to send attachements in messages
  has_many_attached :attachments, dependent: :destroy

  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?

    if target.image?  
      target.variant(resize_to_limit: [150, 150]).processed
    elsif target.video?
      target.variant(resize_to_limit: [150, 150]).processed
    end
  end

  # when a message is created, update the room's last_message_at
  def update_parent_room
    room.update(last_message_at: Time.now)
  end
end