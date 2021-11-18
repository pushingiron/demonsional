class RatesController < ApplicationController
  before_action :set_rate, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /rates or /rates.json
  def index
    @rates = current_user.rates.all
  end

  # GET /rates/1 or /rates/1.json
  def show
  end

  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates or /rates.json
  def create
    @rate = Rate.new(rate_params)

    respond_to do |format|
      if @rate.save
        format.html { redirect_to @rate, notice: "Rate was successfully created." }
        format.json { render :show, status: :created, location: @rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rates/1 or /rates/1.json
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: "Rate was successfully updated." }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1 or /rates/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url, notice: "Rate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def load_rates
    Rate.load_rates(current_user)
    redirect_to rates_path
  end

  def destroy_all
    if current_user.rates.first.present?
      current_user.rates.destroy_all
      redirect_to rates_path, notice: 'All rates deleted'
    else
      redirect_to rates_path, notice: 'Nothing to deleted'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rate_params
      params.require(:rate).permit(:user_id, :contract_id, :lane_calc, :from_loccode, :from_city, :from_state, :from_zip, :from_country, :to_loccode, :to_city, :to_state, :to_zip, :to_country, :scac, :service, :mode, :break_1_field, :break_1_min, :break_1_max, :break_2_field, :break_2_min, :break_2_max, :rate_field, :rate_calc, :rate, :accessorial1_field, :accessorial1_calc, :accessorial1_rate, :total_min)
    end
end
