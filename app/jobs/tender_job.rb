class TenderJob < ApplicationJob

  include MercuryGateService

  def perform
    @transports = mg_post_list_report 'Transport', 'Tender Reject'
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_tender_response(row, 'D'))
    end
    @transports = mg_post_list_report 'Transport', 'Tender Accept'
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_tender_response(row, 'A'))
    end
    PickupJob.set(wait: 1.0.minutes).perform_later
  end
end
