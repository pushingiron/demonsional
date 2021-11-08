class PickupJob < ApplicationJob

  include MercuryGateService

  REPORT_TYPE = 'Transport'.freeze
  REPORT_NAME = 'AD_In_Transit'.freeze
  STATUS_CODE = 'AF'.freeze

  def perform
    @transports = mg_post_list_report REPORT_TYPE, REPORT_NAME
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_status(row, STATUS_CODE))
    end
    DeliveredJob.set(wait: 3.minutes).perform_later
  end
end
