class Room < ApplicationRecord
  # before_create do
  #   opentok = OpenTok::OpenTok.new Rails.application.credentials.vonage_api_key, Rails.application.credentials.vonage_api_secret
  #   session = opentok.create_session
  #   self.vonage_session_id = session.session_id
  # end

  after_initialize :assigned_vonage_session_id_to_existing_rooms

  validates_uniqueness_of :name                        
  scope :public_rooms, -> { where(is_private: false) } 

  # turbo_rails - broadcast when created
  # after_create_commit { broadcast_append_to "rooms" }
  after_create_commit { broadcast_if_public }
  # only broadcast if public because if private, we already broadcast through the User model
  # all(for now) or online users are shown on the tab, so the room already exist(broadcasted)

  has_many :joinables, dependent: :destroy                    # dependent destroy: it means that when room is deleted, joinables will be gone, too
  has_many :joined_users, through: :joinables, source: :user  # look thru joinables & find users that belongs to room, results are Users model

  has_many :messages#, dependent: :destroy
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

  private
  def assigned_vonage_session_id_to_existing_rooms
    if self.vonage_session_id.nil?
      opentok = OpenTok::OpenTok.new Rails.application.credentials.vonage_api_key, Rails.application.credentials.vonage_api_secret
      session = opentok.create_session
      self.vonage_session_id = session.session_id
    end
  end
end