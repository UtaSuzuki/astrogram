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
end
