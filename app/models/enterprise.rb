class Enterprise < ApplicationRecord
  belongs_to :user

  include REXML

  WS_USER_ID = 'geer_shipper_ws'.freeze
  WS_PASSWORD = 'geer1234'.freeze
  WS_URL = 'https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp'.freeze


  ENTERPRISE_ATTRIBUTES = %w[company_name customer_account active location_code location_name address_1
                             address_2 city state postal country residential comments earliest_appt
                             latest_appt location_type contact_type contact_name contact_phone contact_fax
                             contact_email].freeze


  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      enterprise = Enterprise.find_or_initialize_by(company_name: row['company_name'], location_code: row['location_code'])
      enterprise.attributes = row.to_hash.slice(*ENTERPRISE_ATTRIBUTES)
      enterprise.save!
    end
  end

  end




