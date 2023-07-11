class Item < ApplicationRecord
  belongs_to :shipping_order
  has_many :item_references, dependent: :delete_all
  accepts_nested_attributes_for :item_references, allow_destroy: true
end
