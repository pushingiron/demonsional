class Enterprise < ApplicationRecord
  belongs_to :user

  ENTERPRISE_ATTRIBUTES = %w[new_name new_acct active location_code location_name address_1
                             address_2 city state postal country residential comments earliest_appt
                             latest_appt location_type contact_type contact_name contact_phone contact_fax
                             contact_email].freeze

  def self.mg_post(enterprise_list, user)
    params = { userid: 'WSDemoID', password: 'demo1234', request: enterprise_xml(enterprise_list, user) }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post('https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp', encoded_params)
    response.body.force_encoding('utf-8')
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      enterprise = Enterprise.find_or_initialize_by(new_acct: row['new_acct'], location_code: row['location_code'])
      enterprise.attributes = row.to_hash.slice(*ENTERPRISE_ATTRIBUTES)
      enterprise.save!
    end
  end
end



def enterprise_xml(enterprise_list, user)

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
        xml.tag! 'WebImportFile'do
          xml.tag! 'MercuryGate' do
            xml.tag! 'Header' do
              xml.SenderID 'MGSALES'
              xml.ReceiverID 'MGSALES'
              xml.OriginalFileName 'ENT-2021031909400044.xml'
              xml.Action 'UpdateOrAdd'
              xml.DocTypeID 'Enterprise'
              xml.DocCount '1'
            end
            enterprise_list.each do | post |
              xml.Enterprise(name: post.new_name, parentName: user.configurations.first.parent, active: post.active,
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
    xml.target!
  end
end
