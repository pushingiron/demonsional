class TenderJob < ApplicationJob

  REPORT_TYPE = 'Transport'.freeze

  def perform(user)

    @rejects = MercuryGateApiServices.mg_post_list_report(user, REPORT_TYPE, Profile.tender_reject_report(user))
    n = 0
    CSV.parse(@rejects, headers: true, col_sep: ',') do |row|
      n += 1
      MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.xml_tender_response(user, row, 'D'))
    end
    @accepts = MercuryGateApiServices.mg_post_list_report(user, REPORT_TYPE, Profile.tender_accept_report(user))
    n = 0
    CSV.parse(@accepts, headers: true, col_sep: ',') do |row|
      n += 1
      MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.xml_tender_response(user, row, 'A'))
    end
    PickupJob.set(wait: 1.minutes).perform_later(user)
  end
end
