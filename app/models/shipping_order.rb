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

  def self.mg_post(shipping_order_list)
    params = { userid: 'WSDemoID', password: 'demo1234', request: shipping_order_xml(shipping_order_list) }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post('https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp', encoded_params)
    response.body.force_encoding('utf-8')
  end
end

def shipping_order_xml(shipping_order_list)

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
                  xml.ReferenceNumber(post.so_match_ref, type: 'Cust Reference Number', isPrimary: false)
                end
                xml.tag! 'Payment' do
                  xml.Method(post.payment_method)
                end
                xml.tag! 'Plan' do
                  xml.Events(count: '2') do
                    xml.Event(type: :Pickup, sequenceNum: '1') do
                      xml.tag! 'Dates' do
                        xml.Date(post.early_pickup_date.strftime("%m/%d/%Y %H:%M"), type: 'planned')
                      end
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
                        xml.tag! 'Shipments' do
                          xml.tag! 'ReferenceNumbers' do
                            xml.ReferenceNumber(post.shipment_match_ref, type: 'Shipment Number')
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
                            xml.ReferenceNumber(post.shipment_match_ref, type: 'Shipment Number')
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
                      xml.ReferenceNumber(post.shipment_match_ref, type: 'Shipment Number')
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
                    xml.tag! 'ItemGroups' do
                      post.items.each do |item|
                        xml.ItemGroup(sequence: item.sequence, id: item.id, isHandlingUnit: item.ship_unit) do
                          xml.LineItem(lineNumber: item.line_number)
                          xml.Description(item.description)
                          xml.FreightClasses do
                            xml.FreightClass(item.freight_class, type: 'ordered',)
                          end
                          xml.tag! 'Weights' do
                            xml.Weight(item.weight, type: 'actual', uom: item.weight_uom)
                          end
                          xml.tag! 'Quantities' do
                            xml.Quantity(item.quantity, type: 'actual', uom: item.quantity_uom)
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
