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
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
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
    p 'new'
    @profile = current_user.profiles.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
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
                                    :call_check_report,
                                    :delivered_report,
                                    :in_transit_report,
                                    :tender_reject_report,
                                    :need_invoice_report)
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end

end
