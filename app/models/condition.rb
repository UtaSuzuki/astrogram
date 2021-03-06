class Condition < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true
  validates :camera, presence: true
  
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_one :itemLink, dependent: :destroy
end
