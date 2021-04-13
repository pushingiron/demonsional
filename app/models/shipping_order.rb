class ShippingOrder < ApplicationRecord

  belongs_to :user
  #has_many :locations

  has_many :pickup_locations, -> { where stop_type: :Pickup}, :class_name => 'Location'
  has_many :drop_locations,  -> { where stop_type: :Drop}, :class_name => 'Location'


  accepts_nested_attributes_for :pickup_locations, allow_destroy: true
  accepts_nested_attributes_for :drop_locations, allow_destroy: true


  #accepts_nested_attributes_for :locations, allow_destroy: true

  has_many :references
  accepts_nested_attributes_for :references, allow_destroy: true

  class PickupLocations
    def self.all
      p 'in PickupLocations'
      ShippingOrder.locations.find_by(stop_type: :Pickup)
    end
  end

end
