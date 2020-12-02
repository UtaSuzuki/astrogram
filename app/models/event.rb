class Event < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true, format: {with: /\A[\w\!\?]+\z/}
  validates :date, presence: true
  validates :start_time, presence: true
  validates :location, presence: true, format: {with: /\A[\w\-\.]+\z/}
  validates :description, presence: true, format: {with: /\A[\w\-\.\!\?]+\z/}
  
  belongs_to :user
  
  mount_uploader :image, ImageUploader
end
