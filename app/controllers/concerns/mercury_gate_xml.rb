module MercuryGateXml

  WS_USER_ID = 'geer_shipper_ws'.freeze

  def xml_tender_response(data)
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
                  xml.ReferenceNumber data['PRO Number'], isPrimary: false, type: 'PRO Number'
                  xml.ReferenceNumber data['SCAC'], isPrimary: false, type: 'SCAC'
                end
                xml.ResponseCode 'D'
              end
            end
          end
        end
      end
    end
    xml.target!
  end

  def xml_list_report_one_prompt(type, name, count = 0, value1 = nil, value2 = nil, value3 = nil)
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

  def enterprise_xml(enterprise_list, parent, ws_user_id)

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
            xml.UserName ws_user_id
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'UpdateOrAdd'
                xml.DocTypeID 'Enterprise'
                xml.DocCount enterprise_list.count
              end
              enterprise_list.each do |post|
                xml.Enterprise(name: post.company_name, parentName: parent, active: post.active,
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
      xml.target!
    end
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

end
