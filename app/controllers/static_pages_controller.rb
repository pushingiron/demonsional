class StaticPagesController < ApplicationController
  include MercuryGateService

  before_action :authenticate_user!

  def index
    @paths = current_user.paths.all
    #@test = Transport.transport_oid
    p @test
  end


  def create_demo
    job_delay = 0.0
    # GuestsCleanupJob.perform_later 'easy'
    @ent_sub_list = %w[Admin Planning Execution Visibility POD FAP Analytics]
    # create enterprises for demo
    # ###########################
    @new_ent = params[:enterprise]
    @pickup_date = Date.parse(params[:pickup_date])
    @parent_ent = current_user.cust_acct
    # create shipping orders for demo
    # ###########################
    ShippingOrder.destroy_all
    Path.create(description: 'Remove shipping orders', object: 'ShippingOrder', action: 'destroy_all', user_id: current_user.id)
    Enterprise.destroy_all
    Path.create(description: 'Remove enterprises orders', object: 'Enterprise', action: 'destroy_all', user_id: current_user.id)
    cust_acct = nil
    p 'Create enterprises in database'
    @ent_sub_list.each do |sub|
      @enterprise_name = "#{@new_ent} #{sub}"
      Enterprise.create(company_name: @enterprise_name) do |e|
        cust_acct = "#{@new_ent}_#{sub}_acct".downcase
        e.customer_account = cust_acct
        e.active = true
        e.user_id = current_user.id
        @admin_name = e.company_name if sub == 'Admin'
      end
      current_user.shipping_orders.import(params[:file], @pickup_date, cust_acct) unless sub == 'Admin'
    end
    current_user.enterprises.all.each do |e|
      @response = mg_post_xml(enterprise_xml(e, @parent_ent, current_user.cust_acct))
      p 'enterprise post'
      p @response
      @parent = e.company_name
      mg_post_xml(contract_xml(@ent_sub_list, @new_ent))
      Path.create(description: "Create #{@enterprise_name}", object: 'Enterprise', action: 'create', user_id: current_user.id)
    end
    CreateSoJob.set(wait: job_delay.minutes).perform_later(current_user)
    Path.create(description: "Create Shipping Order job for #{@enterprise_name}", object: 'Job', action: 'schedule', user_id: current_user.id)
    Path.create(description: 'Create contract', object: 'Contract', action: 'create', user_id: current_user.id)
    redirect_to paths_path
  end

  def xml_response
    @xml = params[:format]
  end

  def tendered
    @xml = mg_post_list_report
  end

  private



end
