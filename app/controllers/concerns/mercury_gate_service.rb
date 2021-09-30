module MercuryGateService
  include REXML
  include MercuryGateXml

  WS_USER_ID = 'geer_shipper_ws'.freeze
  WS_PASSWORD = 'geer1234'.freeze
  WS_URL = 'https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp'.freeze

  def mg_post_list_report
    params = { userid: WS_USER_ID, password: WS_PASSWORD, 
               request: xml_list_report_one_prompt('Transport', 'Tender Reject') }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post(WS_URL, encoded_params)
    response.body.force_encoding('utf-8')
    xml_results = Document.new(response.body)
    data_csv = XPath.first(xml_results, '//service-response/data')
    n = 0
    CSV.parse(data_csv.text, headers: true, col_sep: ',') do |row|
      n += 1
      mg_post_xml(xml_tender_response(row))
    end
  end

  def mg_post_xml(payload)
    params = { userid: WS_USER_ID, password: WS_PASSWORD, request: payload }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post(WS_URL, encoded_params)
    response.body.force_encoding('utf-8')
    xml_results = Document.new(response.body)
  end

end
