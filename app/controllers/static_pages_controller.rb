class StaticPagesController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def so_demos(enterprise)
    file = File.join(Rails.root, 'app/assets', 'data', 'SO Automation.csv')
    p file
    current_user.shipping_orders.import(file)
    @shipping_orders = current_user.shipping_orders.all
    @shipping_orders.each do |so|
      so.early_pickup_date = (Date.parse "#{@pickup_date}") + 8.hours
      so.late_pickup_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 5.days + 16.hours
      so.early_delivery_date = (Date.parse "#{@pickup_date} 08:00:00.000000000") + 1.days + 8.hours
      so.late_delivery_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 6.days + 16.hours
      so.cust_acct_num = enterprise
    end
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference, current_user.shipment_match_reference)
    p @response
  end


  def create_demo
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
      so_demos(cust_acct) unless t == 'Admin'
    end
  end

  def xml_response
    @xml = params[:format]
  end

  def edge_status
    @user = current_user
    p @user
    json = { authentication: { username: @user.edge_pack_id, password: @user.edge_pack_pwd } }.to_json
    p json
    uri = URI "https://#{@user.edge_pack_url}/execjs"
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = false
    res = http.post2 uri.path, json, 'Content-Type' => 'application/json'
    p res.body
  end

end
