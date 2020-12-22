class Card < ApplicationRecord
  validates :user_id, presence: true
  validates :customer_id, presence: true
  validates :default_card_id, presence: true
  
  belongs_to :user
end
