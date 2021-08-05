class StaticPagesController < ApplicationController

  before_action :authenticate_user!

  def index; end


  def create_demo
    job_delay = 0.0
    GuestsCleanupJob.perform_later 'easy'
    @ent = %w[Admin Planning Execution Visibility POD FAP Analytics]
    # create enterprises for demo
    # ###########################
    @enterprise = params[:enterprise]
    @pickup_date = params[:pickup_date]
    @parent = current_user.cust_acct
    Enterprise.destroy_all
    cust_acct = nil
    @ent.each do |t|
      @enterprise_name = "#{@enterprise} #{t}"
      Enterprise.create(company_name: @enterprise_name) do |e|
        cust_acct = "#{@enterprise}_#{t}_acct".downcase
        e.customer_account = cust_acct
        e.active = true
        e.user_id = current_user.id
        @active_parent = e.company_name if t == 'Admin'
      end
      @enterprises = current_user.enterprises.all
      @response = Enterprise.mg_post(@enterprises, @parent, current_user.cust_acct)
      @parent = @active_parent
      # create shipping orders for demo
      # ###########################
      ShippingOrder.destroy_all
      CreateSoJob.set(wait: job_delay.minutes).perform_later(cust_acct, current_user, @pickup_date, @enterprise, t) unless t == 'Admin'
      job_delay += 0.5
    end
    redirect_to root_path
  end

  def xml_response
    @xml = params[:format]
  end

  private

=begin
  def so_demos(enterprise)
    file = File.join(Rails.root, 'app/assets', 'data', 'SO Automation.csv')
    current_user.shipping_orders.import(file)
    @shipping_orders = current_user.shipping_orders.all
    @shipping_orders.each do |so|
      so.early_pickup_date = (Date.parse "#{@pickup_date}") + 8.hours
      so.late_pickup_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 5.days + 16.hours
      so.early_delivery_date = (Date.parse "#{@pickup_date} 08:00:00.000000000") + 1.days + 8.hours
      so.late_delivery_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 6.days + 16.hours
      so.cust_acct_num = enterprise
    end
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference,
                                      current_user.shipment_match_reference)
  end
=end

  def run_mmo(enterprise)
    @user = current_user
    rates = current_user.rates.pluck(:contract_id, :lane_calc, :from_loccode, :from_city, :from_state, :from_zip,
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
             script: "Edge.switchCompany('#{enterprise} Planning');
                      ship = Edge.getServerReport('Shipment', 'Planning', true);
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
  end

end
