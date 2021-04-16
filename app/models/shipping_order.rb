class ShippingOrder < ApplicationRecord

  belongs_to :user

  has_many :pickup_locations, -> { where stop_type: :Pickup}, class_name: 'Location'
  has_many :drop_locations,  -> { where stop_type: :Drop}, class_name: 'Location'


  accepts_nested_attributes_for :pickup_locations, allow_destroy: true
  accepts_nested_attributes_for :drop_locations, allow_destroy: true

  has_many :references
  accepts_nested_attributes_for :references, allow_destroy: true

  has_many :items
  accepts_nested_attributes_for :items, allow_destroy: true

  SHIPPING_ORDER_ATTRIBUTES = %w[payment_method cust_acct_num user_id so_match_ref shipment_match_ref].freeze
  REFERENCE_ATTRIBUTES = %w[id reference_type reference_value is_primary].freeze
  LOCATION_ATTRIBUTES = %w[id shipping_order_id loc_code name address1 address2 city state postal country geo 
                           residential comments earliest_appt latest_appt stop_type loc_type].freeze
  ITEM_ATTRIBUTES = [].freeze

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      shipping_order = ShippingOrder.find_or_initialize_by(so_match_ref: row['so_match_ref'])
      p '######'
      p row
      shipping_order.attributes = row.to_hash.slice(*SHIPPING_ORDER_ATTRIBUTES)
      shipping_order.save!
      ref_list = row['references']
      CSV.parse(ref_list, col_sep: '.', row_sep: '|') do |ref_row|
        reference = Reference.find_or_initialize_by(shipping_order_id: shipping_order.id, reference_type: ref_row[0])
        #reference.attributes = row.to_hash.slice(*REFERENCE_ATTRIBUTES)
        reference.reference_type = ref_row[0]
        reference.reference_value = ref_row[1]
        reference.is_primary = ref_row[2]
        #        reference.attributes = ref_row.to_hash.slice(*REFERENCE_ATTRIBUTES)
        reference.save!
      end
    end
  end

end
