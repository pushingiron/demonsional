class StaticPagesController < ApplicationController

  before_action :authenticate_user!

  def index; end


  def create_demo
    job_delay = 0.0
    GuestsCleanupJob.perform_later 'easy'
    @ent_sub_list = %w[Admin Planning Execution Visibility POD FAP Analytics]
    # create enterprises for demo
    # ###########################
    @new_ent = params[:enterprise]
    @pickup_date = params[:pickup_date]
    @parent_ent = current_user.cust_acct
    # create shipping orders for demo
    # ###########################
    ShippingOrder.destroy_all
    current_user.shipping_orders.import(params[:file])
    sleep(10)
    Enterprise.destroy_all
    cust_acct = nil

    # Create enterprises in database
    @ent_sub_list.each do |sub|
      @enterprise_name = "#{@new_ent} #{sub}"
      Enterprise.create(company_name: @new_ent) do |e|
        cust_acct = "#{@new_ent}_#{sub}_acct".downcase
        e.customer_account = cust_acct
        e.active = true
        e.user_id = current_user.id
        @admin_name = e.company_name if sub == 'Admin'
      end
      @all_ent = current_user.enterprises.all
      @response = Enterprise.mg_post(@all_ent, @parent_ent, current_user.cust_acct)
      @parent = @admin_name
      unless sub == 'Admin'
        CreateSoJob.set(wait: job_delay.minutes).perform_later(cust_acct, current_user, @pickup_date, @new_ent, sub)
      end
      job_delay += 0.5
    end
    Enterprise.mg_post_con(@parent, @ent_sub_list, @new_ent)
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



end
