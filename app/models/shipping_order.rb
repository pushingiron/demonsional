class ShippingOrder < ApplicationRecord

  belongs_to :user

  has_many :pickup_locations, -> { where stop_type: :Pickup}, class_name: 'Location'
  has_many :delivery_locations,  -> { where stop_type: :Drop}, class_name: 'Location'


  accepts_nested_attributes_for :pickup_locations, allow_destroy: true
  accepts_nested_attributes_for :delivery_locations, allow_destroy: true

  has_many :references
  accepts_nested_attributes_for :references, allow_destroy: true

  has_many :items
  accepts_nested_attributes_for :items, allow_destroy: true

  SHIPPING_ORDER_ATTRIBUTES = %w[payment_method cust_acct_num user_id so_match_ref shipment_match_ref].freeze
  REFERENCE_ATTRIBUTES = %w[id reference_type reference_value is_primary].freeze
  LOCATION_ATTRIBUTES = %w[id shipping_order_id loc_code name address1 address2 city state postal country geo
                           residential comments earliest_appt latest_appt stop_type loc_type].freeze
  ITEM_ATTRIBUTES = %w[type sequence line_number description freight_class weight weight_uom quantity quantity_uom
                       cube cube_uom].freeze

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      shipping_order = ShippingOrder.find_or_initialize_by(so_match_ref: row['so_match_ref'])
      shipping_order.attributes = row.to_hash.slice(*SHIPPING_ORDER_ATTRIBUTES)
      shipping_order.save!
      origin_location = shipping_order.pickup_locations.find_or_initialize_by(loc_code: row['pickup_loc_code'])
      load_location(origin_location, row, "pickup")
      load_location(origin_location, row, "delv")
      # start dealing with parsing out references and submitting to DB
      ref_list = row['references']
      CSV.parse(ref_list, col_sep: '.', row_sep: '|') do |ref_row|
        reference = Reference.find_or_initialize_by(shipping_order_id: shipping_order.id, reference_type: ref_row[0])
        reference.reference_type = ref_row[0]
        reference.reference_value = ref_row[1]
        reference.is_primary = ref_row[2]
        reference.save!
      end
      # deal with line items
      items = shipping_order.items.find_or_initialize_by(line_number: row['line_number'])
      items.attributes = row.to_hash.slice(*ITEM_ATTRIBUTES)
      items.save!
    end
  end

  def self.load_location(location, row, prefix)
    location.loc_type = row["#{prefix}_loc_type"]
    location.loc_code = row["#{prefix}_loc_code"]
    location.name = row["#{prefix}_name"]
    location.address1 = row["#{prefix}_address1"]
    location.address2 = row["#{prefix}_address2"]
    location.city = row["#{prefix}_city"]
    location.state = row["#{prefix}_state"]
    location.postal = row["#{prefix}_postal"]
    location.country = row["#{prefix}_country"]
    location.geo = row["#{prefix}_geo"]
    location.residential = row["#{prefix}_residential"]
    location.comments = row["#{prefix}_comments"]
    location.earliest_appt = row["#{prefix}_earliest_appt"]
    location.latest_appt = row["#{prefix}_latest_appt"]
    location.save!
  end
end
