class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @profiles = current_user.profiles
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profiles_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def new
    @profile = current_user.profiles.new
    @profile.edge_pack_id = 'test'
    @profile.cust_acct = 'automation... (need to replace this)'
    @profile.shipment_match_reference = 'shipment_match_ref'
    @profile.so_match_reference = 'so_match_ref'
    @profile.edge_pack_url = '73.181.185.52:8001'
    @profile.edge_pack_id = 'DemoTopEdgePack'
    @profile.edge_pack_pwd = 'demo1234'
    @profile.ws_user_id = '..shipper_ws... (need to replace this)'
    @profile.ws_user_pwd = '..password... (need to replace this)'
    @profile.report_user = '..Automation... (need to replace this)'
    @profile.server = 'demo5'
    @profile.active = true
    @profile.mmo_shipment_report = 'AD_Optimize (may need to replace this)'
    @profile.contract_report = 'AD_Contract (may need to replace this)'
    @profile.pool_report = 'AD_Pool (may need to replace this)'
    @profile.call_check_report = 'AD_Call_Check (may need to replace this)'
    @profile.delivered_report = 'AD_Delivered (may need to replace this)'
    @profile.in_transit_report = 'AD_In_Transit (may need to replace this)'
    @profile.tender_accept_report = 'AD_Tender_Accept (may need to replace this)'
    @profile.tender_reject_report = 'AD_Tender_Reject (may need to replace this)'
    @profile.need_invoice_report = 'AD_Need_Invoice (may need to replace this)'
  end

  def create
    @profile = current_user.profiles.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profiles_path, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:cust_acct,
                                    :shipment_match_reference,
                                    :so_match_reference,
                                    :edge_pack_url,
                                    :edge_pack_id,
                                    :edge_pack_pwd,
                                    :ws_user_id,
                                    :ws_user_pwd,
                                    :report_user,
                                    :email,
                                    :password,
                                    :password_confirmation,
                                    :remember_me,
                                    :server,
                                    :active,
                                    :mmo_shipment_report,
                                    :contract_report,
                                    :pool_report,
                                    :call_check_report,
                                    :delivered_report,
                                    :in_transit_report,
                                    :tender_accept_report,
                                    :tender_reject_report,
                                    :invoice_report)
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end

end
