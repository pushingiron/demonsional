class DeliveredJob < ApplicationJob

  REPORT_TYPE = 'Transport'.freeze
  STATUS_CODE = 'D1'.freeze

  def perform(user)
    report_name = Profile.delivered_report(user)
    @transports = (MercuryGateApiServices.mg_post_list_report user, REPORT_TYPE, report_name).match(/<data>(.*?)<\/data>/m)[1]
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      Path.create(description: "Creating Actual Delivery", object: 'Delivery Job', action: 'begin', user_id: user.id,
                  data: MercuryGateXml.xml_status(user, row, STATUS_CODE))
      @response = MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.xml_status(user, row, STATUS_CODE))
    end
    InvoiceJob.set(wait: 1.minutes).perform_later(user)
  end
end
