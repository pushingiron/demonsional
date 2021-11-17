class DeliveredJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  REPORT_NAME = 'AD_Delivered'.freeze
  STATUS_CODE = 'D1'.freeze

  def perform(user)
    @transports = mg_post_list_report user, REPORT_TYPE, REPORT_NAME
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(user, xml_status(row, STATUS_CODE))
    end
  end
end
