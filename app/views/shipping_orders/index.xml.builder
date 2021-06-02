# frozen_string_literal: true

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
          @shipping_orders.each do |post|
            xml.Load(type: 'CustomerLoad', action: 'UPDATEORADD') do
              xml.tag! 'ReferenceNumbers' do
                Reference.where(shipping_order_id: post.id).each do |ref|
                  xml.ReferenceNumber(ref.reference_value, type: ref.reference_type, isPrimary: ref.is_primary)
                end
                xml.ReferenceNumber(post.so_match_ref, type: current_user.configurations.first.so_match, isPrimary: false)
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
                          xml.ReferenceNumber(post.shipment_match_ref, type: current_user.configurations.first.shipment_match)
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
                          xml.ReferenceNumber(post.shipment_match_ref, type: current_user.configurations.first.shipment_match)
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
                    xml.ReferenceNumber(post.shipment_match_ref, type: current_user.configurations.first.shipment_match)
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
                  xml.tag! 'ItemGroups' do
                    post.items.each do |item|
                      xml.ItemGroup(sequence: item.sequence, id: item.id, isHandlingUnit: item.ship_unit) do
                        xml.FreightClasses do
                          xml.FreightClass(item.freight_class, type: 'ordered',)
                        end
                        xml.tag! 'Weights' do
                          if item.weight_plan.positive?
                            xml.Weight(item.weight_plan, type: 'planned', uom: item.weight_uom)
                          end
                          if item.weight_actual.positive?
                            xml.Weight(item.weight_actual, type: 'actual', uom: item.weight_uom)
                          end
                          if item.weight_delivered.positive?
                            xml.Weight(item.weight_delivered, type: 'delivered', uom: item.weight_uom)
                          end
                        end
                        xml.tag! 'Quantities' do
                          if item.weight_plan.positive?
                            xml.Quantity(item.quantity, type: 'planned', uom: item.quantity_uom)
                          end
                          if item.weight_actual.positive?
                            xml.Quantity(item.quantity, type: 'actual', uom: item.quantity_uom)
                          end
                          if item.weight_delivered.positive?
                            xml.Quantity(item.quantity, type: 'delivered', uom: item.quantity_uom)
                          end
                        end
                        xml.Description(item.description)
                        xml.LineItem(lineNumber: item.line_number) do
                          xml.CustomsValue(item.customs_value) if item.customs_value.positive?
                          xml.ManufacturingCountry(item.manufacturing_country) unless item.manufacturing_country.nil?
                        end

                      end
                    end
                  end
                  xml.tag! 'EquipmentList' do
                    xml.Equipment(code: post.equipment_code)
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

