class PickupJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  STATUS_CODE = 'AF'.freeze

  def perform(user)
    report_name = Profile.in_transit_report(user)
    @transports = mg_post_list_report(user, REPORT_TYPE, report_name)
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_status(user, row, STATUS_CODE))
    end
    CallCheckJob.set(wait: 1.minutes).perform_later(user)
  end
end
