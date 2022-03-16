class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # devise already take care of uniquess for user
  scope :all_except, ->(user) { where.not(id: user) }

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

  private
  def add_default_avatar
    return if avatar.attached?                                                          # if have an avatar => good

    avatar.attach(                                                                      # if not, attach our own default image
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),     # path to image
      filename: 'default_avatar.png',
      content_type: 'image/png'
    )
  end
end
