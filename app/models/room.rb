class Room < ApplicationRecord
  validates_uniqueness_of :name                        
  scope :public_rooms, -> { where(is_private: false) } 

  # turbo_rails - broadcast when created
  # after_create_commit { broadcast_append_to "rooms" }
  after_create_commit { broadcast_if_public }
  # only broadcast if public because if private, we already broadcast through the User model
  # all(for now) or online users are shown on the tab, so the room already exist(broadcasted)

  has_many :messages
  has_many :participants, dependent: :destroy

  def broadcast_if_public 
    broadcast_append_to "rooms" unless self.is_private
  end

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end

    single_room
  end

  def has_participant?(room, user)
    room.participants.where(user_id: user.id, room_id: room.id).exists?
  end
end