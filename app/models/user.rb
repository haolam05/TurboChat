class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # devise already take care of uniquess for user
  scope :all_except, ->(user) { where.not(id: user) }

  # joinable
  has_many :joinables, dependent: :destroy                     # dependent destroy: it means that when user is deleted, joinables will be gone, too
  has_many :joined_rooms, through: :joinables, source: :room   # look thru joinables & find rooms that user has joined, results are Rooms model

  # role
  enum role: %i[user admin]                                    # enum: states, represented in binary => role user/admin --> evaluates to a state integer --> assigned to role:integer of User
  after_initialize :set_default_role, if: :new_record?
  #after_initialize :set_admin

  
  # turbo_rails - broadcast when created
  after_create_commit { broadcast_append_to "users" }
  has_many :messages

  # for avatar with devise
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]

  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  def chat_avatar
    avatar.variant(resize_to_limit: [50, 50]).processed
  end


  # broadcast for status
  after_update_commit { broadcast_update }
  enum status: %i[offline away online]

  def broadcast_update  # turbo stream from <div id="user_status"> 
    broadcast_replace_to 'user_status', partial: 'users/status', user: self   # replace user status partial with the user_self(updated)
  end

  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    else
      'bg-dark'
    end
  end

  # Check if user's joined rooms includes this room
  def has_joined_room(room)
    joined_rooms.include?(room)
  end
  
  private
  def add_default_avatar
    return if avatar.attached?                                                          # if have an avatar => good

    avatar.attach(                                                                      # if not, attach our own default image
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),     # path to image
      filename: 'default_avatar.png',
      content_type: 'image/png'
    )
  end
  
  def set_default_role      # default role to be user
    self.role ||= :user
  end

  def set_admin
    if self.email == "tuonghao2001@gmail.com"
      self.role = :admin
    end
  end
end
