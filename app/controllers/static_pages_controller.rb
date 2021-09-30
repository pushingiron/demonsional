class StaticPagesController < ApplicationController
  include MercuryGateService

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
      @response = mg_post_xml(enterprise_xml(current_user.enterprises.all, @parent_ent, current_user.cust_acct))
      @parent = @admin_name
      unless sub == 'Admin'
        CreateSoJob.set(wait: job_delay.minutes).perform_later(cust_acct, current_user, @pickup_date, @new_ent, sub)
      end
      job_delay += 0.5
    end
    mg_post_xml(contract_xml(@ent_sub_list, @new_ent))
    redirect_to root_path
  end

  def xml_response
    @xml = params[:format]
  end

  def tendered
    @xml = mg_post_list_report
  end

  private



end
