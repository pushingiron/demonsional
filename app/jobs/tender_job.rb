class TenderJob < ApplicationJob

  include MercuryGateService

  def perform
    @transports = mg_post_list_report 'Transport', 'Tender Reject'
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_tender_response(row))
    end
  end
end
