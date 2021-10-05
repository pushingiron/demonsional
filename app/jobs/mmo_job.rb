class MmoJob < ApplicationJob
  queue_as :mmo

  def perform(user, enterprise, ent_suf)
    Path.create(description: "Starting MMO for #{ent_suf}", object: 'Job', action: 'begin', user_id: user.id)
    @user = user
    rates = user.rates.pluck(:contract_id, :lane_calc, :from_loccode, :from_city, :from_state, :from_zip,
                                     :from_country, :to_loccode, :to_city, :to_state, :to_zip, :to_country, :scac,
                                     :service, :mode, :break_1_field, :break_1_min, :break_1_max, :break_2_field,
                                     :break_2_min, :break_2_max, :rate_field, :rate_calc, :rate, :accessorial1_field,
                                     :accessorial1_calc, :accessorial1_rate, :total_min)
    p rates
    @headers = ['Contract Id', 'Lane Calc', 'From Loccode', 'From City', 'From State', 'From Zip', 'From Country',
                'To Loccode', 'To City', 'To State', 'To Zip', 'To Country', 'SCAC', 'Service', 'Mode',
                'Break 1 Field', 'Break 1 Min', 'Break 1 Max', 'Break 2 Field', 'Break 2 Min', 'Break 2 Max',
                'Rate Field', 'Rate Calc', 'Rate', 'Accessorial1 Field', 'Accessorial1 Calc', 'Accessorial1 Rate',
                'Total Min']
    hash = { authentication: { username: @user.edge_pack_id, password: @user.edge_pack_pwd },
             inputReports: [{ name: 'Rates', type: 'RateTable',
                              headers: @headers, data: rates }],
             script: "Edge.switchCompany('#{enterprise} #{ent_suf}');
                      ship = Edge.getServerReport('Shipment', 'Planning Template', true);
                      Edge.mojoExecute(ship, 'test', false);
                      Edge.mojoCreateServerLoads(false)"
    }

    json = hash.to_json
    uri = URI "https://#{@user.edge_pack_url}/execjs"
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = false
    http.write_timeout = 5000
    http.open_timeout = 5000
    http.read_timeout = 5000
    res = http.post2 uri.path, json.to_s, 'Content-Type' => 'application/json'
    Path.create(description: "MMO complete for #{ent_suf}", object: 'job', action: 'end', user_id: user.id)
    TenderJob.set(wait: 1.25.minutes).perform_later if ent_suf == 'Analytics'
  end

end
