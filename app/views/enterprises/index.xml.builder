
# frozen_string_literal: true

xml = Builder::XmlMarkup.new
xml.instruct! :xml, version: '1.0'
xml.tag! 'service-request' do
  xml.tag! 'service-id', 'ImportWeb'
  xml.tag! 'request-id', '2021031909400044'
  xml.tag! 'data' do
    xml.tag! 'WebImport' do
      xml.tag! 'WebImportHeader' do
        xml.FileName 'ENT-2021031909400044.xml'
        xml.Type 'WebImportEnterprise'
        xml.UserName 'WSDemTopLoaderID'
      end
      xml.tag! 'WebImportFile'
      xml.tag! 'MercuryGate' do
        xml.tag! 'Header' do
          xml.SenderID 'MGSALES'
          xml.ReceiverID 'MGSALES'
          xml.OriginalFileName 'ENT-2021031909400044.xml'
          xml.Action 'UpdateOrAdd'
          xml.DocTypeID 'Enterprise'
          xml.DocCount '1'
        end
        @enterprises.each do | post |
          xml.Enterprise(name: post.company_name, parentName: current_user.configurations.first.parent, active: post.active,
                         action: :UpdateOrAdd) do
            xml.MultiNational(false)
            xml.Description
            xml.DisplayNotes
            xml.CustomerAcctNum(post.customer_account)
            xml.tag! 'ReferenceNumbers' do
              xml.ReferenceNumber(post.customer_account, type: 'Cust Reference Num')
            end
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

