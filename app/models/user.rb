class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 15}
  validates :email, presence: true, uniqueness: true, format: {with: /\A[\w\-\.]+@[a-zA-Z\d\-]+\.[a-zA-Z]+\z/}
  validates :password, confirmation: true, format: {with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]{8,32}\z/}
  validates :kind, inclusion: {in: %w(normal creater)}
  
  has_secure_password
  
  has_many :conditions, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :participant_events, through: :participants, source: 'event'
  has_one  :card, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :favorites
  has_many :favorite_photos, through: :favorites, source: 'photo'
  has_many :photo_comments
  has_many :photo_comments_photos, through: :photo_comments, source: 'photo'
  has_many :event_comments
  has_many :event_comments_events, through: :evnet_comments, source: 'event'
  has_many :relationships
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy  # フォロー取得
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy  # フォロワー取得
  has_many :following_user, through: :follower, source: :followed    # 自分がフォローしている人
  has_many :follower_user,  through: :followed, source: :follower    # 自分をフォローしている人
  
  # ユーザをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  # ユーザのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
end
