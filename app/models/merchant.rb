class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  class << self
    def all_merchants(page_number = 1, per_page = 20)
      page_number = 1 if page_number <= 0
      Merchant.all.limit(per_page).offset((page_number - 1).abs * per_page)
    end
  end
end