module MercuryGateApiServices

    require 'rexml/document'
    include REXML
    include MercuryGateXml
    include MercuryGateJson
    include Base64

    WS_URL_PROTOCOL = 'https://'.freeze
    WS_URL_URL = '.mercurygate.net/MercuryGate/common/remoteService.jsp'.freeze
    def self.mg_post_list_report(user, type, name, count = 0, value1 = nil, value2 = nil, value3 = nil)
      ws_user_id = Profile.ws_user_id(user).freeze
      ws_password = Profile.ws_user_pwd(user).freeze
      ws_url = WS_URL_PROTOCOL + Profile.server_name(user) + WS_URL_URL
      params = { userid: ws_user_id, password: ws_password,
                 request: MercuryGateXml.xml_list_report(user, type, name, count, value1, value2, value3) }
      encoded_params = URI.encode_www_form(params)
      response = Faraday.post(ws_url, encoded_params)
      response.body.force_encoding('utf-8')
      processed_response = response.body.gsub('&', '&amp;')
      xml_results = Document.new(processed_response)
      report_data = XPath.first(xml_results, '//service-response/data').to_s
      report_data
    end

    def self.mg_post_xml(user, payload)
      ws_user_id = Profile.ws_user_id(user)
      ws_password = Profile.ws_user_pwd(user)
      ws_url = WS_URL_PROTOCOL + Profile.server_name(user) + WS_URL_URL
      params = { userid: ws_user_id, password: ws_password, request: payload }
      encoded_params = URI.encode_www_form(params)
      faraday = Faraday.new do |f|
        f.options.timeout = 1000000
      end
      response = faraday.post(ws_url, encoded_params)
      Document.new(response.body)
    end

    def self.mg_post_edge(user, data_hash, end_point)
      json = data_hash.to_json
      uri = URI "https://#{Profile.edge_pack_url(user)}/#{end_point}"
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = false
      http.write_timeout = 5000
      http.open_timeout = 5000
      http.read_timeout = 5000
      response = http.post(uri.path, json.to_s, 'Content-Type' => 'application/json')
      response.body
    end

    def self.mg_get_edge(user, data_hash, end_point)
      uri = URI "https://#{Profile.edge_pack_url(user)}/#{end_point}"
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = false
      http.write_timeout = 5000
      http.open_timeout = 5000
      http.read_timeout = 5000
      response = http.get(uri.path)
      response.body
    end

  end
