class ContractsController < ApplicationController
  before_action :set_contract, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def show; end

  def index
    @contracts = current_user.contracts
  end

  def new
    @contract = current_user.contracts.new
  end

  def edit

  end

  def create
    @contract = current_user.contracts.new(contract_params)

    respond_to do |format|
      if @contract.save
        format.html { redirect_to @contract, notice: 'Contract was successfully created.' }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to @contract, notice: "Contract was successfully updated." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract.destroy
    respond_to do |format|
      format.html { redirect_to contracts_path, notice: "Contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def copy
    old_contract = current_user.contracts.find(params[:format])
    @contract = old_contract.dup
    @contract.contract_name = "#{old_contract.contract_name} copy"
    if @contract.save
      redirect_to edit_contract_path(@contract)
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @contract.errors, status: :unprocessable_entity }
    end
  end

  def create_base
    @contract = current_user.contracts.new(contract_name: :Omni,
                                           owner: 'Geer Automated Setup',
                                           web_service: true,
                                           service: :Standard,
                                           service_days: 0,
                                           mode: :TL,
                                           effective_date: '2001-01-01',
                                           expiration_date: '2099-01-01',
                                           contract_type: 'CARRIER CONTRACT',
                                           is_multi_stop: true,
                                           disable_distance_non_mg: false,
                                           disable_distance_mg: false,
                                           is_gain_share: false,
                                           discount_type: :Flat,
                                           discount_flat_value: 0,
                                           smc_min_dis_enabled: false,
                                           minimum: 99,
                                           re_rate_date_type: :PlannedShipDate,
                                           distance_determiner: :PCMiler19,
                                           distance_route_type: :Practical,
                                           transit_time: nil,
                                           weekend_holiday_adj: :Default,
                                           oversize_charges: false,
                                           show_zero: false,
                                           dim_factor: 0,
                                           dim_weight_calc: :Default,
                                           dimensional_rounding: false,
                                           dim_weight_min_cube: 0,
                                           include_rto_miles: false,
                                           require_dimensions: false,
                                           qty_density_weight: 0,
                                           do_not_return_indirect_charges: false,
                                           uplift_per: 0,
                                           uplift_type: 'UPLIFT LINE HAUL',
                                           uplift_min: 0,
                                           uplift_max: 0,
                                           exclude_pct_acc_from_uplift: false,
                                           uplift: nil,
                                           user_id: current_user.id,
                                           carrier_name: :OMNI,
                                           carrier_enterprise: 'Demo Top',
                                           smc_minimum: nil,
                                           rate_table: 'OMNI RATING.xls',
                                           accessorial_profile: 'LTL Fuel')
    respond_to do |format|
      if @contract.save
        format.html { redirect_to @contract, notice: 'Contract was successfully created.' }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(
      :contract_name,
      :owner,
      :carrier_name,
      :carrier_enterprise,
      :web_service,
      :service,
      :service_days,
      :mode,
      :effective_date,
      :expiration_date,
      :contract_type,
      :is_multi_stop,
      :disable_distance_non_mg,
      :disable_distance_mg,
      :is_gain_share,
      :discount_type,
      :discount_flat_value,
      :smc_min_dis_enabled,
      :minimum,
      :re_rate_date_type,
      :distance_determiner,
      :distance_route_type,
      :transit_time,
      :weekend_holiday_adj,
      :oversize_charges,
      :show_zero,
      :dim_factor,
      :dim_weight_calc,
      :dimensional_rounding,
      :dim_weight_min_cube,
      :include_rto_miles,
      :require_dimensions,
      :qty_density_weight,
      :do_not_return_indirect_charges,
      :uplift_per,
      :uplift_type,
      :uplift_min,
      :uplift_max,
      :exclude_pct_acc_from_uplift,
      :uplift,
      :rate_table,
      :accessorial_profile
    )

  end

end
