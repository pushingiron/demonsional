module MercuryGateJson

  RATE_HEADERS = ['Contract Id', 'Lane Calc', 'From Loccode', 'From City', 'From State', 'From Zip', 'From Country',
                  'To Loccode', 'To City', 'To State', 'To Zip', 'To Country', 'SCAC', 'Service', 'Mode',
                  'Break 1 Field', 'Break 1 Min', 'Break 1 Max', 'Break 2 Field', 'Break 2 Min', 'Break 2 Max',
                  'Rate Field', 'Rate Calc', 'Rate', 'Accessorial1 Field', 'Accessorial1 Calc', 'Accessorial1 Rate',
                  'Total Min'].freeze

  def rate_table(user, enterprise)
    rates = user.rates.pluck(:contract_id, :lane_calc, :from_loccode, :from_city, :from_state, :from_zip,
                             :from_country, :to_loccode, :to_city, :to_state, :to_zip, :to_country, :scac,
                             :service, :mode, :break_1_field, :break_1_min, :break_1_max, :break_2_field,
                             :break_2_min, :break_2_max, :rate_field, :rate_calc, :rate, :accessorial1_field,
                             :accessorial1_calc, :accessorial1_rate, :total_min)

    { authentication: { username: user.edge_pack_id, password: user.edge_pack_pwd },
      inputReports: [{ name: 'Rates', type: 'RateTable',
                       headers: RATE_HEADERS, data: rates }],
      script: "Edge.switchCompany('#{enterprise}');
                      ship = Edge.getServerReport('Shipment', 'Planning Template', true);
                      Edge.mojoExecute(ship, 'test', false);
                      Edge.mojoCreateServerLoads(false)" }

  end

  def auth_mmo(user)

    "{ authentication: { username: #{Profile.edge_pack_id(user)}, password: #{Profile.edge_pack_pwd(user)} } }"

  end

end
