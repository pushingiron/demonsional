class ShippingOrder < ApplicationRecord

  belongs_to :user

  has_many :pickup_locations, -> { where stop_type: :Pickup}, class_name: 'Location', dependent: :delete_all
  has_many :delivery_locations,  -> { where stop_type: :Drop}, class_name: 'Location', dependent: :delete_all


  accepts_nested_attributes_for :pickup_locations, allow_destroy: true
  accepts_nested_attributes_for :delivery_locations, allow_destroy: true

  has_many :references, dependent: :delete_all
  accepts_nested_attributes_for :references, allow_destroy: true

  has_many :items, dependent: :delete_all
  accepts_nested_attributes_for :items, allow_destroy: true

  SHIPPING_ORDER_ATTRIBUTES = %w[payment_method cust_acct_num user_id so_match_ref shipment_match_ref early_pickup_date
                                 late_pickup_date early_delivery_date late_delivery_date demo_type equipment_code].freeze

  REFERENCE_ATTRIBUTES = %w[id reference_type reference_value is_primary].freeze

  LOCATION_ATTRIBUTES = %w[id shipping_order_id loc_code name address1 address2 city state postal country geo
                           residential comments earliest_appt latest_appt stop_type loc_type].freeze

  ITEM_ATTRIBUTES = %w[type sequence line_number description freight_class weight_actual weight_uom quantity quantity_uom
                       cube cube_uom weight_plan weight_delivered country_of_origin country_of_manufacture customs_value
                       customs_value_currency origination_country manufacturing_country].freeze

  def self.import(file)
    so_prev = nil
    CSV.foreach(file.path, headers: true) do |row|
      shipping_order = ShippingOrder.find_or_initialize_by(so_match_ref: row['so_match_ref'])
      if row['so_match_ref'] != so_prev
        shipping_order.attributes = row.to_hash.slice(*SHIPPING_ORDER_ATTRIBUTES)
        shipping_order.save!
        after_save {so_id = id}
        origin_location = shipping_order.pickup_locations.find_or_initialize_by(loc_code: row['pickup_loc_code'])
        load_location(origin_location, row, "pickup")
        origin_location.save!
        delivery_location = shipping_order.delivery_locations.find_or_initialize_by(loc_code: row['delv_loc_code'])
        load_location(delivery_location, row, "delv")
        delivery_location.save!
        # start dealing with parsing out references and submitting to DB
        ref_list = row['references']
        unless ref_list.blank?
          begin
            Reference.find_by(shipping_order_id: shipping_order.id).destroy
          rescue NoMethodError
            CSV.parse(ref_list, col_sep: '.', row_sep: '|') do |ref_row|
              reference = Reference.find_or_initialize_by(shipping_order_id: shipping_order.id, reference_type: ref_row[0])
              reference.reference_type = ref_row[0]
              reference.reference_value = ref_row[1]
              reference.is_primary = ref_row[2]
              reference.save!
            end
          end
        end
        # deal with line items
        Item.where(shipping_order_id: shipping_order.id).find_each(&:destroy)
        items = shipping_order.items.find_or_initialize_by(line_number: row['line_number'])
        items.attributes = row.to_hash.slice(*ITEM_ATTRIBUTES)
        items.save!
      else
        items = shipping_order.items.find_or_initialize_by(line_number: row['line_number'])
        items.attributes = row.to_hash.slice(*ITEM_ATTRIBUTES)
        items.save!
      end
      so_prev = row['so_match_ref']
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

  def self.mg_post(shipping_order_list, configs)
    params = { userid: 'WSDemoID', password: 'demo1234', request: shipping_order_xml(shipping_order_list, configs) }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post('https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp', encoded_params)
    response.body.force_encoding('utf-8')
  end
end

def shipping_order_xml(shipping_order_list, configs)

  xml = Builder::XmlMarkup.new
  xml.instruct! :xml, version: '1.0'
  xml.tag! 'service-request' do
    xml.tag! 'service-id', 'ImportWeb'
    xml.tag! 'request-id', '2021031909400044'
    xml.tag! 'data' do
      xml.tag! 'WebImport' do
        xml.tag! 'WebImportHeader' do
          xml.FileName 'SO-2021031909400044.xml'
          xml.Type 'WebImportShippingOrder'
          xml.UserName 'WSDemTopLoaderID'
        end
        xml.tag! 'WebImportFile'do
          xml.tag! 'MercuryGate' do
            xml.tag! 'Header' do
              xml.SenderID 'MGSALES'
              xml.ReceiverID 'MGSALES'
              xml.OriginalFileName 'SO-2021031909400044.xml'
              xml.Action 'UpdateOrAdd'
              xml.DocTypeID 'ShippingOrder'
              xml.DocCount '1'
            end
            shipping_order_list.each do |post|
              xml.Load(type: 'CustomerLoad', action: 'UPDATEORADD') do
                xml.tag! 'ReferenceNumbers' do
                  Reference.where(shipping_order_id: post.id).each do |ref|
                    xml.ReferenceNumber(ref.reference_value, type: ref.reference_type, isPrimary: ref.is_primary)
                  end
                  xml.ReferenceNumber(post.so_match_ref, type: configs.so_match, isPrimary: false)
                end
                xml.tag! 'Payment' do
                  xml.Method(post.payment_method)
                end
                xml.tag! 'EquipmentList' do
                  xml.Equipment(code: post.equipment_code)
                end
                xml.tag! 'Plan' do
                  xml.Events(count: '2') do
                    xml.Event(type: :Pickup, sequenceNum: '1') do
                      xml.tag! 'Dates' do
                        xml.Date(post.early_pickup_date.strftime("%m/%d/%Y %H:%M"), type: 'planned')
                      end
                      post.pickup_locations.each do |pickup|
                        xml.Address(type: pickup.loc_type, isPrimary: false, isResidential: pickup.residential) do
                          xml.LocationCode(pickup.loc_code)
                          xml.Name(pickup.name)
                          xml.AddrLine1(pickup.address1)
                          xml.AddrLine2(pickup.address2)
                          xml.City(pickup.city)
                          xml.StateProvince(pickup.state)
                          xml.PostalCode(pickup.postal)
                          xml.CountryCode(pickup.country)
                        end
                        xml.tag! 'Shipments' do
                          xml.tag! 'ReferenceNumbers' do
                            xml.ReferenceNumber(post.shipment_match_ref, type: configs.shipment_match)
                          end
                        end
                      end
                    end
                    xml.Event(type: :Drop, sequenceNum: '2') do
                      xml.tag! 'Dates' do
                        xml.Date(post.early_delivery_date.strftime("%m/%d/%Y %H:%M"), type: 'planned')
                      end
                      post.delivery_locations.each do |delivery|
                        xml.Address(type: delivery.loc_type, isPrimary: false, isResidential: delivery.residential) do
                          xml.LocationCode(delivery.loc_code)
                          xml.Name(delivery.name)
                          xml.AddrLine1(delivery.address1)
                          xml.AddrLine2(delivery.address2)
                          xml.City(delivery.city)
                          xml.StateProvince(delivery.state)
                          xml.PostalCode(delivery.postal)
                          xml.CountryCode(delivery.country)
                        end
                        xml.tag! 'Shipments' do
                          xml.tag! 'ReferenceNumbers' do
                            xml.ReferenceNumber(post.shipment_match_ref, type: configs.shipment_match)
                          end
                        end
                      end
                    end
                  end
                end
                xml.tag! 'Shipments' do
                  xml.Shipment(type: 'REGULAR', action: 'UPDATEORADD') do
                    xml.Status('Pending')
                    xml.tag! 'ReferenceNumbers' do
                      xml.ReferenceNumber(post.shipment_match_ref, type: configs.shipment_match)
                    end
                    xml.tag! 'Dates' do
                      xml.tag! 'Pickup' do
                        xml.Date(post.early_pickup_date.strftime("%m/%d/%Y %H:%M"), type: 'earliest')
                        xml.Date(post.late_pickup_date.strftime("%m/%d/%Y %H:%M"), type: 'latest')
                      end
                      xml.tag! 'Drop' do
                        xml.Date(post.early_delivery_date.strftime("%m/%d/%Y %H:%M"), type: 'earliest')
                        xml.Date(post.late_delivery_date.strftime("%m/%d/%Y %H:%M"), type: 'latest')
                      end
                    end
                    xml.tag! 'Shipper' do
                      post.pickup_locations.each do |pickup|
                        xml.Address(type: pickup.loc_type, isPrimary: false, isResidential: pickup.residential) do
                          xml.LocationCode(pickup.loc_code)
                          xml.Name(pickup.name)
                          xml.AddrLine1(pickup.address1)
                          xml.AddrLine2(pickup.address2)
                          xml.City(pickup.city)
                          xml.StateProvince(pickup.state)
                          xml.PostalCode(pickup.postal)
                          xml.CountryCode(pickup.country)
                        end
                      end
                    end
                    xml.tag! 'Consignee' do
                      post.delivery_locations.each do |delivery|
                        xml.Address(type: delivery.loc_type, isPrimary: false, isResidential: delivery.residential) do
                          xml.LocationCode(delivery.loc_code)
                          xml.Name(delivery.name)
                          xml.AddrLine1(delivery.address1)
                          xml.AddrLine2(delivery.address2)
                          xml.City(delivery.city)
                          xml.StateProvince(delivery.state)
                          xml.PostalCode(delivery.postal)
                          xml.CountryCode(delivery.country)
                        end
                      end
                    end
                    item_seq = 0
                    xml.tag! 'ItemGroups' do
                      post.items.each do |item|
                        item_seq += 1
                        xml.ItemGroup(sequence: item_seq, id: item.id, isHandlingUnit: item.ship_unit) do
                          xml.FreightClasses do
                            xml.FreightClass(item.freight_class, type: 'ordered')
                          end
                          xml.tag! 'Weights' do
                            unless item.weight_plan.nil?
                              if item.weight_plan.positive?
                                xml.Weight(item.weight_plan, type: 'planned', uom: item.weight_uom)
                              end
                            end
                            unless item.weight_actual.nil?
                              if item.weight_actual.positive?
                                xml.Weight(item.weight_actual, type: 'actual', uom: item.weight_uom)
                              end
                            end
                            unless item.weight_delivered.nil?
                              if item.weight_delivered.positive?
                                xml.Weight(item.weight_delivered, type: 'delivered', uom: item.weight_uom)
                              end
                            end
                          end
                          xml.tag! 'Quantities' do
                            unless item.weight_plan.nil?
                              if item.weight_plan.positive?
                                xml.Quantity(item.quantity, type: 'planned', uom: item.quantity_uom)
                              end
                            end
                            unless item.weight_actual.nil?
                              if item.weight_actual.positive?
                                xml.Quantity(item.quantity, type: 'actual', uom: item.quantity_uom)
                              end
                            end
                            unless item.weight_delivered.nil?
                              if item.weight_delivered.positive?
                                xml.Quantity(item.quantity, type: 'delivered', uom: item.quantity_uom)
                              end
                            end
                          end
                          xml.Description(item.description)
                          xml.LineItem(lineNumber: item.line_number) do
                            unless item.customs_value.nil?
                              xml.CustomsValue(item.customs_value) if item.customs_value.positive?
                            end
                            unless item.manufacturing_country.nil?
                              xml.ManufacturingCountry(item.manufacturing_country) unless item.manufacturing_country.nil?
                            end
                          end
                        end
                      end
                    end
                    xml.tag! 'Payment' do
                      xml.Method(post.payment_method)
                      xml.BillTo(thirdParty: false) do
                        post.pickup_locations.each do |pickup|
                          xml.Address(type: pickup.loc_type, isPrimary: false, isResidential: pickup.residential) do
                            xml.Name(pickup.name)
                            xml.AddrLine1(pickup.address1)
                            xml.AddrLine2(pickup.address2)
                            xml.City(pickup.city)
                            xml.StateProvince(pickup.state)
                            xml.PostalCode(pickup.postal)
                            xml.CountryCode(pickup.country)
                          end
                        end
                      end
                    end
                  end
                end
                xml.Enterprise(customerAcctNum: post.cust_acct_num)
              end
            end
          end
        end
      end
    end
    xml.target!
  end
end
