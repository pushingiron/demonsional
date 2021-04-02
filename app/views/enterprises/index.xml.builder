
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
        xml.Enterprise(name: post.new_name, parentname: post.parent, active: post.active,
                       action: :UpdateOrAdd) do
          xml.MultiNational(false)
          xml.Description
          xml.DisplayNotes
          xml.CustomerAcctNum(post.new_acct)
          xml.ReferenceNumbers
          xml.FederalEIN
          xml.DUNS
          xml.PrimarySIC
          xml.Ranking
          xml.CreditLimitManagement(limit: ' ')
          xml.Visibility(login: true, quote: true)
          xml.EnterpriseRoles
          xml.EnterpriseRoles(type: :customer, required: false)
          xml.Locations
        end
        end
      end
    end
  end
  end

@output = xml.target!
p 'xml'
p @output

