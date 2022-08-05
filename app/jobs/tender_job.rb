class TenderJob < ApplicationJob

  include MercuryGateService
  REPORT_TYPE = 'Transport'.freeze

  def perform(user)

    report_name = Profile.tender_reject_report(user)

    @transports = mg_post_list_report(user, REPORT_TYPE, report_name)
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_tender_response(user, row, 'D'))
    end
    @transports = mg_post_list_report(user, 'Transport', 'Tender Accept')
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_tender_response(user, row, 'A'))
    end
    PickupJob.set(wait: 1.minutes).perform_later(user)
  end
end
