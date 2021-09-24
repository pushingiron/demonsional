@enterprises = %w[Admin Planning Execution Visibility POD FAP Analytics]
@ent_name = current_user.cust_acct

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
        xml.Type 'WebContract'
        xml.UserName 'ws_user_id'
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
            xml.Owner 'enterprise'
            xml.Carrier 'Swift Transport', ownEntName: 'Demo Top'
            xml.IsWebService true
            xml.Service 'Standard'
            xml.ServiceDays 0
            xml.Mode "LTL"
            xml.EffectiveDate
            xml.ExpirationDate
            xml.ExpirationReason
            xml.Type 'CARRIER CONTRACT'
            xml.Role
            xml.IsMultiStopTruckload false
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
            xml.ShowZeroRate
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
              @enterprises.each do |post|
                xml.Name "#{@ent_name} #{post}"
              end
            end
            xml.NegotiatedLanes do
              xml.NegotiatedLane do
                xml.Name 'US to US'
                xml.IsExclusionary false
                xml.ServiceAreaMethod 'CC'
                xml.ScoreAdjustment 0
                xml.Discount type: :flat do
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
                        xml.EffectiveDate "09/13/2001 13:31"
                        xml.ExpirationDate "09/13/2099 13:31"
                      end
                    end
                  end
                end
              end
            end
            xml.ReferenceNumbers do
              xml.ReferenceNumber "Per_Mile_MultiStopV3Acc.xls", type: :AltRateDoc, isPrimary: :false
            end
          end
        end
      end
    end
  end
  xml.target!
end