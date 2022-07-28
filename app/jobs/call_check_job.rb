class CallCheckJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  REPORT_NAME = 'AD_Call_Check'.freeze
  STATUS_CODE = 'AF'.freeze

  def perform(user)
    @transports = mg_post_list_report(user, REPORT_TYPE, REPORT_NAME)
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_call_check(user, row))
    end
    DeliveredJob.set(wait: 1.minutes).perform_later(user)
  end
end
