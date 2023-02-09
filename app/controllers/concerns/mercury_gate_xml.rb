module MercuryGateXml

  require 'rexml/document'
  include REXML

  CITY = 'Omaha'.freeze
  STATE = 'NE'.freeze
  DAY_VARIANCE = 0
  PRIREF_VALUE = '//MercuryGate/MasterBillOfLading/ReferenceNumbers/ReferenceNumber[@isPrimary = "true"]/text()'.freeze
  PRIREF_TYPE = '//MercuryGate/MasterBillOfLading/ReferenceNumbers/ReferenceNumber[@isPrimary = "true"]/@type'.freeze
  CUST_ACCT = '//MercuryGate/MasterBillOfLading/ReferenceNumbers/ReferenceNumber[@type = "Customer Acct Number"]/@type'.freeze
  BILL_TO = '//MercuryGate/MasterBillOfLading/Payment/BillTo'.freeze
  SCAC = '//MercuryGate/MasterBillOfLading/Carriers/Carrier/SCAC/text()'.freeze
  PRICE_SHEET = '//MercuryGate/MasterBillOfLading/PriceSheets/PriceSheet[@isSelected = "true" and  @type = "Charge"]'.freeze
  CHARGES = '//MercuryGate/MasterBillOfLading/PriceSheets/PriceSheet[@isSelected = "true" and  @type = "Charge"]/Charges'.freeze


  def xml_extract(oid, service_type)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', service_type
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.oid oid
      end
    end
    xml.target!
  end

  def code_table_xml(code_table)
    p code_table
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'CodeTable'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.codeTableName code_table
      end
    end
    xml.target!
  end

  def xml_status(user, data, status_code)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "STATUS-#{request_id}.xml"
            xml.Type 'WebImportStatus'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'Add'
                xml.DocTypeID 'Status'
              end
              xml.Status shipmentId: data['Primary Reference'].chomp(' (Load ID)'), proNumber: data['PRO Number'], carrierSCAC: data['SCAC'] do
                xml.ReferenceNumbers do
                  xml.ReferenceNumber data['Primary Reference'].chomp(' (Load ID)'), type: 'Load ID'
                end
                xml.Locations do
                  xml.Location addr1: data['Origin Addr1'], addr2: data['Origin Addr2'], city: data['Origin City'],
                               countryCode: data['Origin Ctry'], postalCode: data['Origin Zip'],
                               state: data['Origin State'], type: data['SH']
                end
                xml.StatusDetails do
                  xml.StatusDetail address: data['Origin Addr1'], apptCode: '', apptReasonCode: '',
                                   cityName: data['Origin City'], countryCode: data['Origin Ctry'],
                                   date: date_format(data['Target Ship (Early)']).to_datetime.strftime('%Y%m%d'),
                                   equipNum: '', equipNumCheckDigit: '', equipDescCode: '', index: '', podName: '',
                                   scacCode: '', stateCode: data['Origin State'], statusCode: status_code,
                                   statusReasonCode: '', stopNum: '', time: '0800'
                end
              end
            end
          end
        end
      end
    end
    xml.target!
  end

  def xml_tender_response(user, data, code)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "TENDER-RESPONSE-#{request_id}.xml"
            xml.Type 'WebImportTenderResponse'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'TenderResponse'
              end
              xml.TenderResponse do
                xml.ReferenceNumbers do
                  xml.ReferenceNumber data['Primary Reference'].chomp(' (Load ID)'), isPrimary: true,
                                                                                     type: 'Shipment ID'
                  xml.ReferenceNumber data['PRO Number'], isPrimary: false, type: 'PRO'
                  xml.ReferenceNumber data['SCAC'], isPrimary: false, type: 'SCAC'
                end
                xml.ResponseCode code
              end
            end
          end
        end
      end
    end
    xml.target!
  end

  def xml_list_report(user, type, name, count = 0, value1 = nil, value2 = nil, value3 = nil)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ListScreen'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.listScreenType type
        xml.reportName name
        xml.UserName Profile.report_user(user)
        if count.positive?
          xml.PromptFieldCount count
          xml.PromptField1 value1 if count >= 1
          xml.PromptField2 value2 if count >= 2
          xml.PromptField value3 if count == 3
        end
      end
    end
  end

  def enterprise_xml(user, enterprise)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "ENT#{request_id}.xml"
            xml.Type 'WebImportEnterprise'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'Enterprise'
                xml.DocCount '1'
              end
              enterprise.each do |post|
                xml.Enterprise(name: post.company_name,
                               parentName: post.parent_name,
                               parentAcctId: post.parent_acct_num,
                               active: post.active,
                                 action: :UpdateOrAdd) do
                  xml.MultiNational(false)
                  xml.Description
                  xml.DisplayNotes
                  xml.CustomerAcctNum(post.customer_account)
                  xml.ReferenceNumbers
                  xml.FederalEIN
                  xml.DUNS
                  xml.PrimarySIC
                  xml.Ranking
                  xml.CreditLimitManagement(limit: ' ')
                  xml.Visibility(login: true, quote: true)
                  xml.EnterpriseRoles
                  xml.EnterpriseRoles(type: :customer, required: false)
                  unless post.location_code.blank?
                    xml.tag! 'Locations' do
                      xml.Address(type: post.location_type, isResidential: post.residential, isPrimary: false ) do
                        xml.LocationCode(post.location_code)
                        xml.Alias(post.location_code)
                        xml.Name(post.location_name)
                        xml.AddrLine1(post.address_1)
                        xml.AddrLine2(post.address_2)
                        xml.City(post.city)
                        xml.StateProvince(post.state)
                        xml.PostalCode(post.postal)
                        xml.CountryCode(post.country)
                        xml.tag! 'Contacts' do
                          unless post.contact_type.blank?
                            xml.Contact(type: post.contact_type) do
                              xml.Name(post.contact_name)
                              xml.tag! 'ContactMethods' do
                                i = 1
                                unless post.contact_email.nil?
                                  xml.ContactMethod(post.contact_phone, sequenceNum: i, type: 'Phone')
                                  i += 1
                                end
                                unless  post.contact_fax.nil?
                                  xml.ContactMethod(post.contact_fax, sequenceNum: i, type: 'Fax')
                                  i += 1
                                end
                                unless post.contact_email.nil?
                                  xml.ContactMethod(post.contact_email, sequenceNum: i, type: 'Email')
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    p xml.target!
  end

  def contract_xml(user, enterprises, new_ent, contract)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "CONTRACT-#{request_id}.xml"
            xml.Type 'WebImportContract'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'Contract'
                xml.DocCount 1
              end
              xml.Contract name: contract.contract_name do
                xml.Owner "#{new_ent} #{enterprises[0]}"
                xml.Carrier contract.carrier_name, ownEntName: contract.carrier_enterprise
                xml.IsWebService contract.web_service
                xml.Service contract.service
                xml.ServiceDays contract.service_days.round(0)
                xml.Mode contract.mode
                xml.EffectiveDate contract.effective_date.strftime('%m/%d/%Y')
                xml.ExpirationDate contract.expiration_date.strftime('%m/%d/%Y')
                xml.ExpirationReason
                xml.Type contract.contract_type
                xml.Role
                xml.IsMultiStopTruckload contract.is_multi_stop
                xml.DisableMultiStopDistanceCalcNonMGRateTable contract.disable_distance_non_mg
                xml.DisableMultiStopDistanceCalcMGRateTable contract.disable_distance_mg
                xml.IsGainshare contract.is_gain_share
                xml.AssociatedCarrierContract
                xml.Discount type: contract.discount_type do
                  xml.FlatValue contract.discount_flat_value
                  xml.SMCMinChargeDiscountEnabled contract.smc_min_dis_enabled
                  xml.SMCMinChargeDiscountValue 0
                end
                xml.Minimum contract.minimum
                xml.ReRateDateType contract.re_rate_date_type
                xml.DistanceDeterminer contract.distance_determiner, routeType: contract.distance_route_type
                xml.TransitTime
                xml.WeekendHolidayAdjusment contract.weekend_holiday_adj
                xml.ApplyOversizeCharges contract.oversize_charges
                xml.ShowZeroRate contract.show_zero
                xml.DimFactor contract.dim_factor
                xml.DimWeightCalcMethod contract.dim_weight_calc
                xml.DimensionalRounding contract.dimensional_rounding
                xml.DimWeightRounding contract.dimensional_rounding
                xml.DimWeightCalcMinCube contract.dim_weight_min_cube
                xml.IncludeRTOMiles contract.include_rto_miles
                xml.RequireDimensions contract.require_dimensions
                xml.QtyDensityWeight contract.qty_density_weight
                xml.DoNotReturnIndirectCharges contract.do_not_return_indirect_charges
                xml.Uplift do
                  xml.Percentage contract.uplift_per
                  xml.Type contract.uplift_type
                  xml.Minimum contract.uplift_min
                  xml.Maximum contract.uplift_max
                  xml.ExcludePctAccFromUplift contract.exclude_pct_acc_from_uplift
                end
                xml.Uplift
                xml.AccessorialProfile contract.accessorial_profile
                xml.GrantedCompanies do
                  enterprises.each do |post|
                    xml.Name "#{new_ent} #{post}" unless post == 'Admin'
                  end
                end
                xml.NegotiatedLanes do
                  xml.NegotiatedLane do
                    xml.Name 'US to US'
                    xml.IsExclusionary false
                    xml.ServiceAreaMethod 'CC'
                    xml.ScoreAdjustment 0
                    xml.Discount type: 'Flat' do
                      xml.FlatValue 0
                      xml.SMCMinChargeDiscountEnabled false
                    end
                    xml.OverrideBaseContractFactor false
                    xml.Minimum 0.0
                    xml.WeightMinimum 0.0
                    xml.WeightMaximum 0.0
                    xml.WeightMinMaxType 'TotalWeight'
                    xml.FreightClassMinimum 0.0
                    xml.FreightClassMaximum 0.0
                    xml.QuantityMinimum 0.0
                    xml.QuantityMaximum 0.0
                    xml.QtyMinMaxType 'ActualQty'
                    xml.LengthMaximum 0.0
                    xml.LengthMaximumUom 'in'
                    xml.WidthMaximum 0.0
                    xml.WidthMaximumUom 'in'
                    xml.HeightMaximum 0.0
                    xml.HeightMaximumUom 'in'
                    xml.CubeMaximum 0.0
                    xml.MilesMinimum 0.0
                    xml.MilesMaximum 0.0
                    xml.BillToLocationCode
                    xml.PaymentTerms
                    xml.EnterpriseLanes do
                      xml.EnterpriseLane do
                        xml.Name 'US'
                        xml.Owner 'enterprise'
                        xml.CarrierId 'SWFT'
                        xml.EnterpriseGeoLanes do
                          xml.EntGeoLane do
                            xml.Name 'US'
                            xml.Type 'OD'
                            xml.OriginCriteria 'All Points'
                            xml.OriginDirIndir 'Direct'
                            xml.OriginCountry 'US'
                            xml.DestCriteria 'All Points'
                            xml.DestDirIndir 'Direct'
                            xml.DestCountry 'US'
                            xml.Approved false
                            xml.Preferred false
                            xml.EffectiveDate '09/13/2001 13:31'
                            xml.ExpirationDate '09/13/2099 13:31'
                          end
                        end
                      end
                    end
                  end
                end
                xml.ReferenceNumbers do
                  xml.ReferenceNumber contract.rate_table, type: :AltRateDoc, isPrimary: :false
                end
              end
            end
          end
        end
      end
      xml.target!
    end
  end

  def object_lookup(object_type, search_by, search_value, search_modifier = nil)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'OidLookup'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.objectType object_type
        xml.searchBy search_by
        xml.searchValue search_value
        xml.searchModifier search_modifier unless search_modifier.nil?
      end
    end
  end

  def date_format(date)
    Time.strptime(date, '%m/%d/%Y %I:%M%p') unless date.nil?
  end

  def shipping_order_xml(user, shipping_order_list)
    so_match = Profile.so_match_reference(user)
    sh_match = Profile.shipment_match_reference(user)

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
            xml.UserName Profile.ws_user_id(user)
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
                references = Reference.where(shipping_order_id: post.id)
                xml.Load(type: 'CustomerLoad', action: 'UPDATEORADD') do
                  xml.tag! 'ReferenceNumbers' do
                    Reference.where(shipping_order_id: post.id).each do |ref|
                      xml.ReferenceNumber(ref.reference_value, type: ref.reference_type, isPrimary: ref.is_primary)
                    end
                    xml.ReferenceNumber(post.so_match_ref, type: so_match, isPrimary: false)
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
                          xml.Date(post.early_pickup_date.strftime('%m/%d/%Y %H:%M'), type: 'planned')
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
                            xml.Contacts do
                              xml.Contact(type: '') do
                                xml.Name(pickup.contact_name)
                                xml.ContactMethods do
                                  xml.ContactMethod(pickup.contact_phone, type: 'Phone', sequenceNun: '1')
                                  xml.ContactMethod(pickup.contact_email, type: 'Email', sequenceNun: '2')
                                end
                              end
                            end
                          end
                          xml.tag! 'Shipments' do
                            xml.tag! 'ReferenceNumbers' do
                              xml.ReferenceNumber(post.shipment_match_ref, type: sh_match)
                            end
                          end
                        end
                      end
                      xml.Event(type: :Drop, sequenceNum: '2') do
                        xml.tag! 'Dates' do
                          xml.Date(post.early_delivery_date.strftime('%m/%d/%Y %H:%M'), type: 'planned')
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
                            xml.Contacts do
                              xml.Contacts do
                                xml.Contact(type: '') do
                                  xml.Name(delivery.contact_name)
                                  xml.ContactMethods do
                                    xml.ContactMethod(delivery.contact_phone, type: 'Phone', sequenceNun: '1')
                                    xml.ContactMethod(delivery.contact_email, type: 'Email', sequenceNun: '2')
                                  end
                                end
                              end
                            end
                          end
                          xml.tag! 'Shipments' do
                            xml.tag! 'ReferenceNumbers' do
                              xml.ReferenceNumber(post.shipment_match_ref, type: sh_match)
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
                        xml.ReferenceNumber(post.shipment_match_ref, type: sh_match)
                        references.each do |ref|
                          xml.ReferenceNumber(ref.reference_value, type: ref.reference_type)
                        end
                      end
                      xml.tag! 'Dates' do
                        xml.tag! 'Pickup' do
                          xml.Date(post.early_pickup_date.strftime('%m/%d/%Y %H:%M'), type: 'earliest')
                          xml.Date(post.late_pickup_date.strftime('%m/%d/%Y %H:%M'), type: 'latest')
                        end
                        xml.tag! 'Drop' do
                          xml.Date(post.early_delivery_date.strftime('%m/%d/%Y %H:%M'), type: 'earliest')
                          xml.Date(post.late_delivery_date.strftime('%m/%d/%Y %H:%M'), type: 'latest')
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
                            xml.Contacts do
                              xml.Contact(type: '') do
                                xml.Name(pickup.contact_name)
                                xml.ContactMethods do
                                  xml.ContactMethod(pickup.contact_phone, type: 'Phone', sequenceNun: '1')
                                  xml.ContactMethod(pickup.contact_email, type: 'Email', sequenceNun: '2')
                                end
                              end
                            end
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
                            xml.Contacts do
                              xml.Contact(type: '') do
                                xml.Name(delivery.contact_name)
                                xml.ContactMethods do
                                  xml.ContactMethod(delivery.contact_phone, type: 'Phone', sequenceNun: '1')
                                  xml.ContactMethod(delivery.contact_email, type: 'Email', sequenceNun: '2')
                                end
                              end
                            end
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
                              if !item.weight_plan.nil? && item.weight_plan.positive?
                                xml.Weight(item.weight_plan, type: 'planned', uom: item.weight_uom)
                              end
                              if !item.weight_actual.nil? && item.weight_actual.positive?
                                xml.Weight(item.weight_actual, type: 'actual', uom: item.weight_uom)
                              end
                              if !item.weight_delivered.nil? && item.weight_delivered.positive?
                                xml.Weight(item.weight_delivered, type: 'delivered', uom: item.weight_uom)
                              end
                            end
                            xml.tag! 'Quantities' do
                              if !item.weight_plan.nil? && item.weight_plan.positive?
                                xml.Quantity(item.quantity, type: 'planned', uom: item.quantity_uom)
                              end
                              if !item.weight_actual.nil? && item.weight_actual.positive?
                                xml.Quantity(item.quantity, type: 'actual', uom: item.quantity_uom)
                              end
                              if !item.weight_delivered.nil? && item.weight_delivered.positive?
                                xml.Quantity(item.quantity, type: 'delivered', uom: item.quantity_uom)
                              end
                            end
                            xml.Description(item.description)
                            xml.LineItem(lineNumber: item.line_number) do
                              xml.Cube(item.cube, uom: item.cube_uom) if !item.cube.nil? && item.cube.positive?
                              if !item.customs_value.nil? && item.customs_value.positive?
                                xml.CustomsValue(item.customs_value)
                              end
                              if !item.manufacturing_country.nil? && !item.manufacturing_country.nil?
                                xml.ManufacturingCountry(item.manufacturing_country)
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

  def carrier_invoice_xml(user, el_xml)
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', '2021031909400044'
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName 'INV-2021031909400044.xml'
            xml.Type 'WebImportInvoice'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName 'INV-2021031909400044.xml'
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'FreightBill'
                xml.DocCount '1'
              end
              xml.FreightBill(action: 'Add') do
                #                xml.Enterprise(customerAcctNum: post.cust_acct_num)
                #                xml.Enterprise( name: '', customerAcctNum: XPath.first(el_xml, CUST_ACCT))
                xml.tag! 'ReferenceNumbers' do
                  xml.ReferenceNumber(XPath.first(el_xml, PRIREF_VALUE), type: XPath.first(el_xml, PRIREF_TYPE), isPrimary: true)
                  xml.ReferenceNumber(XPath.first(el_xml, SCAC), type: 'SCAC', isPrimary: false)
                end
                xml.tag! 'PriceSheets' do
                  xml.PriceSheet type: 'Carrier', isSelected: false, currencyCode: 'USD' do
                    xml.tag! 'Carrier' do
                      xml.SCAC XPath.first el_xml, SCAC
                    end
                    xml.tag! 'Charges' do
                      XPath.each(el_xml, "#{CHARGES}//Charge") do |c|
                        puts "in charges: #{c}"
                        description = XPath.first c, 'Description/text()'
                        if description == "Discount"
                          type = "DISCOUNT"
                        elsif description == "Contract Minimum Reached"
                          type = "MG_MINMAX_ADJ"
                        elsif description == "Fuel Surcharge"
                          type = "ACCESSORIAL_FUEL"
                        else
                          type = "ITEM"
                        end
                        xml.Charge sequenceNum: XPath.first(c, '@sequenceNum'), type: type, itemGroupId: '' do
                          amount = (XPath.first c, 'Amount/text()').to_s.to_f
                          description = XPath.first c, 'Description/text()'
                          rate_qualifier = XPath.first(c, 'RateQualifier/text()')
                          rate = (XPath.first c, 'Rate/text()').to_s.to_f
                          # amount = amount.to_s.to_f * 1.1
                          quantity = (XPath.first c, 'Quantity/text()').to_s.to_f
                          xml.Description description
                          xml.RateQualifier rate_qualifier
                          xml.Rate rate
                          xml.Quantity quantity
                          xml.Amount amount.to_s
                        end
                      end
                      xml.Charge sequenceNum: 99, type: "ITEM", itemGroupId: '' do
                        xml.Description "Detention"
                        xml.RateQualifier "Hourly"
                        xml.Rate 200
                        xml.Quantity 1
                        xml.Amount 200.to_s
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      puts xml.target!
    end
  end

  def xml_call_check(user, el_xml)

    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', '2021031909400044'
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName 'INV-2021031909400044.xml'
            xml.Type 'WebImportCallCheck'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate', specVersion: "" do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName 'INV-2021031909400044.xml'
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'CallCheck'
                xml.DocCount '1'
                xml.Date Time.now.strftime("%m/%d/%Y %H:%M:%S"), type: 'create'
              end
              xml.MasterBillOfLading(primaryReference: el_xml['Primary Reference'].chomp(' (Load ID)')) do
                xml.tag! 'CallChecks' do
                  xml.tag! "CallCheck" do
                    xml.tag! "Address" do
                      xml.City el_xml['Call Check City']
                      xml.StateProvince el_xml['Call Check State']
                      xml.GeoLoc
                    end
                    xml.Comments 'test'
                    p '******'
                    p el_xml['Target Ship (Early)']
                    p ship_date = DateTime.strptime(el_xml['Target Ship (Early)'].gsub('/', "_"), '%m_%d_%Y %I:%M%p')
                    # Date.strptime("6/15/2012", '%m/%d/%Y %h:%m')
                    #date = DateTime.parse("07/22/2022 8:00 AM")
                    # p DateTime.strptime(ship_date, '%d.%m.%y')
                    # date = el_xml['Target Ship (Early)'].to_time
                    xml.DateTime((ship_date + 1).strftime('%m/%d/%Y %I:%M:%S'))
                    xml.StatusCode 'X6'
                  end
                end
              end
            end
          end
        end
      end
      puts xml.target!
    end
  end

end

