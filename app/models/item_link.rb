class ItemLink < ApplicationRecord
  validates :nLink, presence: true
  
  belongs_to :condition
end
