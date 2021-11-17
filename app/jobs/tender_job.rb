class TenderJob < ApplicationJob

  include MercuryGateService

  def perform(user)
    @transports = mg_post_list_report(user, 'Transport', 'Tender Reject')
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_tender_response(row, 'D'))
    end
    @transports = mg_post_list_report(user,'Transport', 'Tender Accept')
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_tender_response(row, 'A'))
    end
    PickupJob.set(wait: 1.minutes).perform_later(user)
  end
end
