class Item < ApplicationRecord
  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details

  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  attachment :image

  scope :where_genre_active, -> { joins(:genre).where(genres: { is_active: true }) }

  def with_tax_price
    (price * 110 / 100.0).ceil
  end

  def self.recommended
    recommends = []
    active_genres = Genre.only_active.includes(:items)
    active_genres.each do |genre|
      item = genre.items.last
      recommends << item if item
    end
    recommends
  end
end
