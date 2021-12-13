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
      if @contract.update(rate_params)
        format.html { redirect_to @contract, notice: "Contract was successfully updated." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
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
      :web_service,
      :service,
      :service_days,
      :mode,
      :effective_date,
      :expiration_date,
      :type,
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
      :uplift)

  end

end
