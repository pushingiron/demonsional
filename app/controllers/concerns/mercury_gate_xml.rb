module MercuryGateXml

  WS_USER_ID = 'geer_shipper_ws'.freeze

  def xml_status(data, status_code)
    p '***xml status***'
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
            xml.UserName WS_USER_ID
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
    p xml.target!
  end

  def xml_tender_response(data, code)
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
            xml.UserName WS_USER_ID
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

  def xml_list_report(type, name, count = 0, value1 = nil, value2 = nil, value3 = nil)
    p 'parmaters xml_list report'
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ListScreen'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.listScreenType type
        xml.reportName name
        xml.UserName 'GeerAutomation'
        if count.positive?
          xml.PromptFieldCount count
          if count >= 1
            xml.PromptField1 value1
          end
          if count >= 2
            xml.PromptField2 value2
          end
          if count == 3
            xml.PromptField value3
          end
        end
      end
    end
  end

  def enterprise_xml(enterprise, parent, ws_user_id)

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
            xml.UserName WS_USER_ID
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
              xml.Enterprise(name: enterprise.company_name, parentName: parent, active: enterprise.active,
                               action: :UpdateOrAdd) do
              xml.MultiNational(false)
              xml.Description
              xml.DisplayNotes
              xml.CustomerAcctNum(enterprise.customer_account)
              xml.ReferenceNumbers
              xml.FederalEIN
              xml.DUNS
              xml.PrimarySIC
              xml.Ranking
              xml.CreditLimitManagement(limit: ' ')
              xml.Visibility(login: true, quote: true)
              xml.EnterpriseRoles
              xml.EnterpriseRoles(type: :customer, required: false)
              unless enterprise.location_code.blank?
                xml.tag! 'Locations' do
                  xml.Address(type: enterprise.location_type, isResidential: enterprise.residential, isPrimary: false ) do
                    xml.LocationCode(enterprise.location_code)
                    xml.Alias(enterprise.location_code)
                    xml.Name(enterprise.location_name)
                    xml.AddrLine1(enterprise.address_1)
                    xml.AddrLine2(enterprise.address_2)
                    xml.City(enterprise.city)
                    xml.StateProvince(enterprise.state)
                    xml.PostalCode(enterprise.postal)
                    xml.CountryCode(enterprise.country)
                    xml.tag! 'Contacts' do
                      unless enterprise.contact_type.blank?
                        xml.Contact(type: enterprise.contact_type) do
                          xml.Name(enterprise.contact_name)
                          xml.tag! 'ContactMethods' do
                            i = 1
                            unless enterprise.contact_email.nil?
                              xml.ContactMethod(enterprise.contact_phone, sequenceNum: i, type: 'Phone')
                              i += 1
                            end
                            unless  enterprise.contact_fax.nil?
                              xml.ContactMethod(enterprise.contact_fax, sequenceNum: i, type: 'Fax')
                              i += 1
                            end
                            unless enterprise.contact_email.nil?
                              xml.ContactMethod(enterprise.contact_email, sequenceNum: i, type: 'Email')
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

    xml.target!
    p xml.target!
  end

  def contract_xml(enterprises, new_ent)
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
            xml.UserName WS_USER_ID
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
              xml.Contract name: 'Test 1' do
                xml.Owner "#{new_ent} #{enterprises[0]}"
                xml.Carrier 'Swift Transport', ownEntName: 'Demo Top'
                xml.IsWebService true
                xml.Service 'Standard'
                xml.ServiceDays 0
                xml.Mode 'TL'
                xml.EffectiveDate '01/01/2012'
                xml.ExpirationDate '01/01/2099'
                xml.ExpirationReason
                xml.Type 'CARRIER CONTRACT'
                xml.Role
                xml.IsMultiStopTruckload true
                xml.DisableMultiStopDistanceCalcNonMGRateTable false
                xml.DisableMultiStopDistanceCalcMGRateTable false
                xml.IsGainshare false
                xml.AssociatedCarrierContract
                xml.Discount type: 'Flat' do
                  xml.FlatValue 0
                  xml.SMCMinChargeDiscountEnabled false
                end
                xml.Minimum 100
                xml.ReRateDateType 'PlannedShipDate'
                xml.DistanceDeterminer 'PCMiler19', routeType: 'Practical'
                xml.TransitTime
                xml.WeekendHolidayAdjusment 'Default'
                xml.ApplyOversizeCharges false
                xml.ShowZeroRate true
                xml.DimFactor 0.0
                xml.DimWeightCalcMethod 'Default'
                xml.DimensionalRounding false
                xml.DimWeightRounding false
                xml.DimWeightCalcMinCube 0.0
                xml.IncludeRTOMiles false
                xml.RequireDimensions false
                xml.QtyDensityWeight 0.0
                xml.DoNotReturnIndirectCharges false
                xml.Uplift do
                  xml.Percentage 0.0
                  xml.Type 'UPLIFT LINE HAUL'
                  xml.Minimum 0.0
                  xml.Maximum 0.0
                  xml.ExcludePctAccFromUplift false
                end
                xml.Uplift
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
                  xml.ReferenceNumber 'Per_Mile_MultiStopV3Acc.xls', type: :AltRateDoc, isPrimary: :false
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
      puts xml.target!
    end
  end

  def date_format(date)
    DateTime.strptime(date, '%m/%d/%Y %I:%M%p')
  end

end

