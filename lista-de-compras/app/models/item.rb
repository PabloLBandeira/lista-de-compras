class Item < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 100 }
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true

  belongs_to :user
end
