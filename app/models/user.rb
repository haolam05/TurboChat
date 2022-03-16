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
end
