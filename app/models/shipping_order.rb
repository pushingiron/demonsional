class ShippingOrder < ApplicationRecord

  require 'roo'

  belongs_to :user

  #validates :so_match_ref, uniqueness: true

  #validates :payment_method, presence: true

  has_many :pickup_locations, -> { where stop_type: :Pickup }, class_name: 'Location', dependent: :delete_all
  has_many :delivery_locations,  -> { where stop_type: :Drop }, class_name: 'Location', dependent: :delete_all
  has_many :bill_to_locations,  -> { where stop_type: :ThirdParty }, class_name: 'Location', dependent: :delete_all


  accepts_nested_attributes_for :pickup_locations, allow_destroy: true
  accepts_nested_attributes_for :delivery_locations, allow_destroy: true

  has_many :references, dependent: :delete_all
  accepts_nested_attributes_for :references, allow_destroy: true

  has_many :items, dependent: :delete_all
  accepts_nested_attributes_for :items, allow_destroy: true

  # has_many :item_references, dependent: :delete_all
  # accepts_nested_attributes_for :item_references, allow_destroy: true

  SHIPPING_ORDER_ATTRIBUTES = %w[payment_method cust_acct_num user_id so_match_ref shipment_match_ref early_pickup_date
                                 late_pickup_date early_delivery_date late_delivery_date demo_type equipment_code shipment_type].freeze

  REFERENCE_ATTRIBUTES = %w[id reference_type reference_value is_primary].freeze

  LOCATION_ATTRIBUTES = %w[id shipping_order_id loc_code name address1 address2 city state postal country geo
                           residential comments earliest_appt latest_appt stop_type loc_type].freeze

  ITEM_ATTRIBUTES = %w[type sequence line_number description freight_class weight_actual weight_uom quantity quantity_uom
                        cube cube_uom weight_plan weight_delivered country_of_origin country_of_manufacture customs_value
                        customs_value_currency origination_country manufacturing_country item_id shipping_order_id
                        is_hazardous proper_shipping_name hazmat_un_na hazmat_group hazmat_class hazmat_ems_number
                        hazmat_contact_name hazmat_contact_phone hazmat_is_placard hazmat_placard_details
                        hazmat_flashpoint hazmat_flashpoint_uom hazmat_comments].freeze

  ITEM_REFERENCE_ATTRIBUTES = %w[id reference_type reference_value is_primary].freeze

  def self.import(file,  cust_acct_num = nil, pickup_date = nil)
    so_prev = nil
    so_id = nil
    begin
      file_path = file.path
    rescue StandardError
      file = open(Rails.root.join('app', 'assets', 'data', 'SO Automation.csv'))
      file_path = file.path
    end
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      shipping_order = ShippingOrder.find_or_initialize_by(so_match_ref: row['so_match_ref'], cust_acct_num: cust_acct_num)
      if row['so_match_ref'] != so_prev
        shipping_order.attributes = row.to_hash.slice(*SHIPPING_ORDER_ATTRIBUTES)
        unless pickup_date.nil?
          shipping_order['early_pickup_date'] = (pickup_date + 8.hours)
          shipping_order['late_pickup_date'] = (pickup_date + 7.days + 16.hours)
          shipping_order['early_delivery_date'] = (pickup_date + 7.days + 8.hours)
          shipping_order['late_delivery_date'] = (pickup_date + 7.days + 16.hours)
        end
        shipping_order['cust_acct_num'] = cust_acct_num unless cust_acct_num.nil?
        shipping_order.save!
        so_id = shipping_order.id
        origin_location = shipping_order.pickup_locations.find_or_initialize_by(loc_code: row['pickup_loc_code'])
        load_location(origin_location, row, 'pickup')
        origin_location.save!
        delivery_location = shipping_order.delivery_locations.find_or_initialize_by(loc_code: row['delv_loc_code'])
        load_location(delivery_location, row, 'delv')
        delivery_location.save!
        bill_to_location = shipping_order.bill_to_locations.find_or_initialize_by(loc_code: row['bill_to_loc_code'])
        load_location(bill_to_location, row, 'bill_to')
        bill_to_location.save!
        # start dealing with parsing out references and submitting to DB
        ref_list = row['references']
        unless ref_list.blank?
          begin
            Reference.find_by(shipping_order_id: shipping_order.id).destroy
          rescue NoMethodError
            CSV.parse(ref_list, col_sep: '.', row_sep: '|') do |ref_row|
              unless ref_row[1].blank?
                reference = Reference.find_or_initialize_by(shipping_order_id: shipping_order.id,
                                                            reference_type: ref_row[0])
                reference.reference_type = ref_row[0]
                reference.reference_value = ref_row[1]
                reference.is_primary = ref_row[2]
                reference.save!
              end
            end
          end
        end
        # deal with 1 line items
        Item.where(shipping_order_id: shipping_order.id).find_each(&:destroy)
        items = shipping_order.items.find_or_initialize_by(line_number: row['line_number'])
        items.attributes = row.to_hash.slice(*ITEM_ATTRIBUTES)
        items.save!
        item_ref_list = row['item_references']
        unless item_ref_list.blank?
          begin
            ItemReference.find_by(item_id: items.id).destroy
          rescue NoMethodError
            CSV.parse(item_ref_list, col_sep: '.', row_sep: '|') do |item_ref_row|
              p item_ref_row
              p item_ref_row[1]
              unless item_ref_row[1].blank?
                item_reference = ItemReference.find_or_initialize_by(item_id: items.id,
                                                                     reference_type: item_ref_row[0])
                item_reference.reference_type = item_ref_row[0]
                item_reference.reference_value = item_ref_row[1]
                item_reference.is_primary = item_ref_row[2]
                item_reference.save!
              end
            end
          end
        end
      else
        p '**** duplicate line'
        items = Item.new(row.to_hash.slice(*ITEM_ATTRIBUTES))
=begin
        items = shipping_order.items.find_or_initialize_by(line_number: row['line_number'])
        items.attributes = row.to_hash.slice(*ITEM_ATTRIBUTES)
=end
        items.shipping_order_id = so_id
        items.save!
        item_ref_list = row['item_references']
        unless item_ref_list.blank?
          begin
            ItemReference.find_by(item_id: items.id).destroy
          rescue NoMethodError
            CSV.parse(item_ref_list, col_sep: '.', row_sep: '|') do |item_ref_row|
              unless item_ref_row[1].blank?
                item_reference = ItemReference.find_or_initialize_by(item_id: items.id,
                                                                     reference_type: item_ref_row[0])
                item_reference.reference_type = item_ref_row[0]
                item_reference.reference_value = item_ref_row[1]
                item_reference.is_primary = item_ref_row[2]
                item_reference.save!
              end
            end
          end
        end
      end
      so_prev = row['so_match_ref']
    end
  end

  def self.open_spreadsheet(file)
    p File.extname(file)
    case File.extname(file)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
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
    location.contact_name = row["#{prefix}_contact_name"]
    location.contact_phone = row["#{prefix}_contact_phone"]
    location.contact_email = row["#{prefix}_contact_email"]
    location.residential = row["#{prefix}_residential"]
    location.comments = row["#{prefix}_comments"]
    location.earliest_appt = row["#{prefix}_earliest_appt"]
    location.latest_appt = row["#{prefix}_latest_appt"]
    location.save!
  end

  def self.mg_post_dep(shipping_order_list, so_match, sh_match, current_user)
    request_xml = shipping_order_xml(current_user, shipping_order_list, so_match, sh_match)
    Path.create(description: "SO XML Prepost", object: 'SO', action: 'Post', user_id: current_user.id, data: request_xml)
    params = { userid: current_user.ws_user_id, password: current_user.ws_user_pwd, request: request_xml }
    encoded_params = URI.encode_www_form(params)
    uri = URI 'https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp'
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.write_timeout = 5000
    http.open_timeout = 5000
    http.read_timeout = 5000
    res = http.post2 uri.path, encoded_params
    p '********'
    p res.body
  end

end

