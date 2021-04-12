class ShippingOrder < ApplicationRecord

  belongs_to :user

  has_many :locations
  accepts_nested_attributes_for :locations, allow_destroy: true

  has_many :references
  accepts_nested_attributes_for :references, allow_destroy: true

end
