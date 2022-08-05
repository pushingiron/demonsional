class CallCheckJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  STATUS_CODE = 'AF'.freeze

  def perform(user)
    report_name = Profile.call_check_report(user)
    @transports = mg_post_list_report(user, REPORT_TYPE, report_name)
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_call_check(user, row))
    end
    DeliveredJob.set(wait: 1.minutes).perform_later(user)
  end
end
