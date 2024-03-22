class StaticPagesController < ApplicationController

  before_action :authenticate_user!


  CODE_TABLES = ["I", "WI:CallCheck", "WI:ShipmentStatus", "WI:ShipmentStatus", "WI:XMLContract", "WI:XMLEnterprise",
                 "WI:XMLPriceSheet", "WI:XMLShippingOrder", "WI:XMLTenderReplyV2", "WI:yuk"].freeze

  def index
    @paths = current_user.paths.all
    @profile = current_user.profiles
    begin
      mmo_status = JSON.parse(MercuryGateApiServices.mg_get_edge(current_user, MercuryGateJson.auth_mmo(current_user), 'serverstatus/json/myTok3141'))
      @mmo_status = mmo_status[0]
      # @mmo_status['content="5"'] = 'content="50"'
    rescue
      @mmo_status = 'Unavailable'
    end
    contracts = MercuryGateApiServices.mg_post_list_report(current_user, 'Contract',
                                                            @profile.contract_report(current_user))
    @contract_report = contracts.empty? ? false : true
    p @contract_report
  end

  def demo_this
    begin
      mmo_status = JSON.parse(MercuryGateApiServices.mg_get_edge(current_user, MercuryGateJson.auth_mmo(current_user),
                                                                 'serverstatus/json/myTok3141'))
      @mmo_status = mmo_status[0]
    rescue
      @mmo_status = 'Unavailable'
    end
    @profile = current_user.profiles.where(active: true)
    @profile.mmo_shipment_report(current_user).blank? ||
    @profile.contract_report(current_user).blank? ||
    @profile.pool_report(current_user).blank? ||
    @profile.call_check_report(current_user).blank? ||
    @profile.delivered_report(current_user).blank? ||
    @profile.tender_accept_report(current_user).blank? ||
    @profile.tender_reject_report(current_user).blank? ||
    @profile.invoice_report(current_user).blank? ||
    @mmo_status == 'Unavailable' ?
      @show_submit = false :
      @show_submit = true
    @report_status = MercuryGateApiServices.mg_post_list_report(current_user, 'Transport', Profile.invoice_report(current_user))
  end

  def mmo_status
    render partial: 'mmo_status'
  end

  def profile_status
    @report_status = mg_post_list_report(current_user, 'Transport', Profile.tender_reject_report(current_user))
  end

  def create_demo
    redirect_to paths_path
    user = current_user
    job_delay = 0.0
    Path.max_records(user) # remove old audit records
    # GuestsCleanupJob.perform_later 'easy'
    if params[:selected_option] == 'multiple_enterprises'
      @ent_sub_list = %w[Admin Planning Execution Visibility POD FAP Analytics]
    else
      @ent_sub_list = %w[Admin Analytics]
    end
    @new_prospect = params[:enterprise] # prospect name
    @pickup_date = Date.parse(params[:pickup_date]) unless params[:pickup_date].empty?
    @parent_ent = Profile.cust_acct(user)
    current_user.shipping_orders.destroy_all
    Path.create(description: 'Remove shipping orders', object: 'ShippingOrder', action: 'destroy_all', user_id: current_user.id)
    current_user.enterprises.destroy_all
    Path.create(description: 'Remove enterprises orders', object: 'Enterprise', action: 'destroy_all', user_id: current_user.id)
    cust_acct = nil
    @ent_sub_list.each do |sub|
      @enterprise_name = "#{@new_prospect} #{sub}"
      current_user.enterprises.create(company_name: @enterprise_name) do |e|
        cust_acct = "#{@new_prospect}_#{sub}_acct".downcase
        e.customer_account = cust_acct
        e.active = true
        e.user_id = user.id
        if sub == 'Admin'
          @admin_name = e.company_name
          e.parent_name = @parent_ent
        else
          e.parent_name = @admin_name
        end
      end
      current_user.shipping_orders.import(params[:file], cust_acct, @pickup_date) unless sub == 'Admin'
    end
    Path.create(description: 'Create Enterprises', object: 'Enterprise', action: 'create', user_id: user.id,
                data: MercuryGateXml.enterprise_xml(user, current_user.enterprises.all))
    @response = MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.enterprise_xml(user, current_user.enterprises.all))
    Path.create(description: 'Completed Creating Enterprises', object: 'Enterprise', action: 'results',
                user_id: user.id, data: @response)
    current_user.contracts.all.each do |c|
      Path.create(description: 'Create contracts', object: 'Contract', action: 'create', user_id: user.id,
                  data: MercuryGateXml.contract_xml(user, @ent_sub_list, @new_prospect, c))
      MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.contract_xml(user, @ent_sub_list, @new_prospect, c))
    end
    CreateSoJob.set(wait: job_delay.minutes).perform_later(user)
    Path.create(description: "Create Shipping Order job", object: 'Job', action: 'schedule', user_id: user.id)
  end

  def xml_response
    @xml = params[:format]
  end

  def so_example
    send_file 'app/assets/data/SO Automation.csv'
  end

  def code_table_status
    CODE_TABLES.each do |c|
      mg_post_xml(current_user, code_table_xml(c))
    end
  end

  private


end
