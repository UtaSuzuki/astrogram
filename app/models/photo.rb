class Photo < ApplicationRecord
  validates :condition_id, presence: true
  validates :categorization_id, presence: true
  validates :size_id, presence: true
  validates :title, presence: true
  validates :image, presence: true
  validates :description, presence: true
  validates :price, presence: true
  
  belongs_to :condition
  has_many :orders, dependent: :destroy
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: 'user'
  has_many :photo_comments
  has_many :photo_comment_users, through: :photo_comments, source: 'user'
  
  mount_uploader :image, ImageUploader
end