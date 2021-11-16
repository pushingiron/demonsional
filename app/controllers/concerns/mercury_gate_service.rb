module MercuryGateService
  include REXML
  include MercuryGateXml

  WS_USER_ID = 'geer_shipper_ws'.freeze
    WS_PASSWORD = 'geer1234'.freeze
  WS_URL = 'https://mgsales.mercurygate.net/MercuryGate/common/remoteService.jsp'.freeze

  def mg_post_list_report(type, name, count = 0, value1 = nil, value2 = nil, value3 = nil)
    p 'mg post list report'
    params = { userid: WS_USER_ID, password: WS_PASSWORD, 
               request: xml_list_report(type, name, count, value1, value2, value3) }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post(WS_URL, encoded_params)
    response.body.force_encoding('utf-8')
    p response
    xml_results = Document.new(response.body)
    report_data = XPath.first(xml_results, '//service-response/data').text
    p '***report data***'
    p report_data
    report_data
  end

  def mg_post_xml(payload)
    puts payload
    params = { userid: WS_USER_ID, password: WS_PASSWORD, request: payload }
    encoded_params = URI.encode_www_form(params)
    response = Faraday.post(WS_URL, encoded_params)
    response.body.force_encoding('utf-8')
    Document.new(response.body)
  end


end
