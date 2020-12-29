class Event < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :location, presence: true
  validates :description, presence: true
  
  belongs_to :user
  has_many :participants
  has_many :participant_users, through: :participants, source: 'user'
  
  mount_uploader :image, ImageUploader
end
