class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_many :tweets
  has_many :follows
  before_create :generate_auth_token

  def generate_auth_token
    auth_token = self.auth_token = SecureRandom.hex(10)
  end

  def followers
  	follower_ids = self.follows.pluck("follower_id")
  	followers = User.where(id: follower_ids)
  end

  def following
  	following_ids = Follow.where(user_id: self.id)
  	followers = User.where(id: following_ids)
  end
end
