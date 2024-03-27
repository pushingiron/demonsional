class Transport < ApplicationRecord

  include MercuryGateXml
  include MercuryGateApiServices

  REPORT_TYPE = 'Transport'.freeze
  IN_TRANSIT_REPORT_NAME = 'in_transit_demo'.freeze
  DELIVERED_REPORT_NAME = 'in_transit_demo'.freeze

  def self.track_in_transit
    @transports = mg_post_list_report REPORT_TYPE, IN_TRANSIT_REPORT_NAME
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      # get transport xml
      # parse xml to get events
      # submit to bing
      # create call checks from bing data
    end
    DeliveredJob.set(wait: 3.minutes).perform_later
  end

  def self.transport_oid
    # oid = Transport.first.object_lookup('transport', 'primaryReference', '1234')
    results = mg_post_xml(Transport.first.object_lookup('transport', 'primaryReference', 'LD8833'))
  end

end
