class InvoiceJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  REPORT_NAME = 'AD_Need_Invoice'.freeze

  def perform(user)
    p 'invoice job'
    oids = mg_post_list_report user, REPORT_TYPE, REPORT_NAME
    p oids
    p 'done'
    n = 0
    CSV.parse(oids, headers: true, col_sep: ',') do |row|
      n += 1
      transport_xml = mg_post_xml user, xml_extract(row[0], 'WebExtractTransportBasic')
      #puts transport_xml
      mg_post_xml user, carrier_invoice_xml(user, transport_xml)
      #pri_ref = XPath.first(transport_xml, "//MercuryGate/MasterBillOfLading/ReferenceNumbers/ReferenceNumber[@isPrimary = \"true\"]/text()")
      # puts pri_ref
      #bill_to = XPath.first(transport_xml, "//MercuryGate/MasterBillOfLading/Payment/BillTo")
      # puts bill_to
      #bill_to_name = XPath.first(bill_to, "//Name/text()")
      # puts bill_to_name
      # pri_type = XPath.first(transport_xml, "//MercuryGate/MasterBillOfLading/ReferenceNumbers/ReferenceNumber[@isPrimary = \"true\"]/@type")
      # puts pri_type
    end
    end
end
