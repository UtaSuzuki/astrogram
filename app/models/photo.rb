class Photo < ApplicationRecord
  validates :condition_id, presence: true
  validates :categorization_id, presence: true
  validates :size_id, presence: true
  validates :title, presence: true
  validates :image, presence: true
  validates :description, presence: true
  validates :price, presence: true
  
  belongs_to :condition
  
  mount_uploader :image, ImageUploader
end
