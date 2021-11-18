class StaticPagesController < ApplicationController
  include MercuryGateService

  before_action :authenticate_user!

  def index
    @paths = current_user.paths.all
    #@test = Transport.transport_oid
    p @test
  end


  def create_demo
    user = current_user
    puts user.report_user
    job_delay = 0.0
    # GuestsCleanupJob.perform_later 'easy'
    @ent_sub_list = %w[Admin Planning Execution Visibility POD FAP Analytics]
    @new_ent = params[:enterprise]
    @pickup_date = Date.parse(params[:pickup_date])
    @parent_ent = current_user.cust_acct
    ShippingOrder.destroy_all
    Path.create(description: 'Remove shipping orders', object: 'ShippingOrder', action: 'destroy_all', user_id: current_user.id)
    Enterprise.destroy_all
    Path.create(description: 'Remove enterprises orders', object: 'Enterprise', action: 'destroy_all', user_id: current_user.id)
    cust_acct = nil
    @ent_sub_list.each do |sub|
      @enterprise_name = "#{@new_ent} #{sub}"
      Enterprise.create(company_name: @enterprise_name) do |e|
        cust_acct = "#{@new_ent}_#{sub}_acct".downcase
        e.customer_account = cust_acct
        e.active = true
        e.user_id = user.id
        if sub == 'Admin'
          @admin_name = e.company_name
          e.parent = @parent_ent
        else
          e.parent = @admin_name
        end
      end
      current_user.shipping_orders.import(params[:file], @pickup_date, cust_acct) unless sub == 'Admin'
    end
    current_user.enterprises.all.each do |e|
      @response = mg_post_xml(user, enterprise_xml(user, e))
      @parent = e.company_name
      mg_post_xml(user, contract_xml(user, @ent_sub_list, @new_ent))
      Path.create(description: "Create #{@enterprise_name}", object: 'Enterprise', action: 'create', user_id: user.id)
    end
    CreateSoJob.set(wait: job_delay.minutes).perform_later(user)
    Path.create(description: "Create Shipping Order job for #{@enterprise_name}", object: 'Job', action: 'schedule', user_id: user.id)
    Path.create(description: 'Create contract', object: 'Contract', action: 'create', user_id: user.id)
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
