class PhotoComment < ApplicationRecord
  validates :message, presence: true
  
  belongs_to :user
  belongs_to :photo
end
