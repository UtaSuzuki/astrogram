class Card < ApplicationRecord
  validates card_number
  validates expiration_year
  validates expiration_month
  validates security_code

  belongs_to :user
end
