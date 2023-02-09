class InvoiceJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze

  def perform(user)
    report_name = Profile.invoice_report(user)
    oids = mg_post_list_report user, REPORT_TYPE, report_name
    n = 0
    CSV.parse(oids, headers: true, col_sep: ',') do |row|
      n += 1
      transport_xml = mg_post_xml user, xml_extract(row[0], 'WebXMLTransportDeep')
      mg_post_xml user, carrier_invoice_xml(user, transport_xml)
    end
    end
end
