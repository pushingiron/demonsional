class StaticPagesController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def demo_this
    p 'demo this'
  end

  def create_demo
    @enterprise = params[:enterprise]
    @pickup_date = params[:pickup_date]
    p @enterprise
    p @pickup_date
    Enterprise.destroy_all
    Enterprise.create(company_name: @enterprise) do |e|
      p 'loop'
      e.customer_account = "#{@enterprise}_acct"
      e.active = true
      e.user_id = current_user.id
    end
    @enterprises = current_user.enterprises.all
    @response = Enterprise.mg_post(@enterprises, current_user)
    p @response
    ShippingOrder.destroy_all
    file = File.join(Rails.root, 'app/assets', 'data', 'SO Automation.csv')
    p file
    current_user.shipping_orders.import(file)
    @shipping_orders = current_user.shipping_orders.all
    @shipping_orders.each do |so|
      so.early_pickup_date = (Date.parse "#{@pickup_date}") + 8.hours
      so.late_pickup_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 5.days + 16.hours
      so.early_delivery_date = (Date.parse "#{@pickup_date} 08:00:00.000000000") + 1.days + 8.hours
      so.late_delivery_date = (Date.parse "#{@pickup_date} 16:00:00.000000000") + 6.days + 16.hours
      p @shipping_orders
    end
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference, current_user.shipment_match_reference)
    p @response
  end

  def xml_response
    p 'in xml_response'
    @xml = params[:format]
    p @xml
  end

end
