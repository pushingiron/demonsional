class PickupJob < ApplicationJob

  include MercuryGateService

  def perform
    @transports = mg_post_list_report 'Transport', 'In Transit'
    n = 0
    CSV.parse(@transports, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_status(row, 'AF'))
    end
  end
end
