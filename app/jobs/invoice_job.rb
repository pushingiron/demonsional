class InvoiceJob < ApplicationJob

  REPORT_TYPE = 'Transport'.freeze

  def perform(user)
    report_name = Profile.invoice_report(user)
    oids = MercuryGateApiServices.mg_post_list_report user, REPORT_TYPE, report_name
    n = 0
    CSV.parse(oids, headers: true, col_sep: ',') do |row|
      n += 1
      transport_xml = MercuryGateApiServices.mg_post_xml user, MercuryGateXml.xml_extract(row[0], 'WebXMLTransportDeep')
      MercuryGateApiServices.mg_post_xml user, MercuryGateXml.carrier_invoice_xml(user, transport_xml)
    end
  end
end
