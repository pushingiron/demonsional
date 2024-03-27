class EnterprisesController < ApplicationController

  include MercuryGateApiServices

  before_action :set_enterprise, except: %i[index post_xml new create import_page import destroy_all create_enterprise_demo csv_example]
  before_action :authenticate_user!



  # GET /enterprises or /enterprises.json or /enterprises.xml
  def index
    @enterprises = current_user.enterprises.all
  end

  def post_xml
    @enterprises = current_user.enterprises.all
    @response = MercuryGateApiServices.mg_post_xml(current_user, enterprise_xml(current_user, @enterprises))
    p @response
    render inline: "<%= @response %><br><%= link_to 'back', enterprises_path %>"
  end

  # GET /enterprises/1 or /enterprises/1.json
  def show; end

  # GET /enterprises/new
  def new
    @enterprise = current_user.enterprises.new
  end

  # GET /enterprises/1/edit
  def edit
  end

  def destroy_all
    if current_user.enterprises.first.present?
      current_user.enterprises.destroy_all
      redirect_to enterprises_path, notice: 'All enterprises deleted'
    else
      redirect_to enterprises_path, notice: 'Nothing to deleted'
    end
  end

  def import_page; end

  def import
    current_user.enterprises.import(params[:file])
    redirect_to root_url, notice: 'Enterprises Imported.'
  end

  # POST /enterprises or /enterprises.json
  def create
    @enterprise = current_user.enterprises.new(enterprise_params)

    respond_to do |format|
      if @enterprise.save
        format.html { redirect_to @enterprise, notice: "Enterprise was successfully created." }
        format.json { render :show, status: :created, location: @enterprise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enterprise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enterprises/1 or /enterprises/1.json
  def update
    respond_to do |format|
      if @enterprise.update(enterprise_params)
        format.html { redirect_to @enterprise, notice: "Enterprise was successfully updated." }
        format.json { render :show, status: :ok, location: @enterprise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enterprise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enterprises/1 or /enterprises/1.json
  def destroy
    @enterprise.destroy
    respond_to do |format|
      format.html { redirect_to enterprises_url, notice: "Enterprise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def csv_example
    send_file 'app/assets/examples/enterprises_example.csv'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_enterprise
    p 'set enterprise!!!!!'
    @enterprise = current_user.cust_acct
  end

    # Only allow a list of trusted parameters through.
  def enterprise_params
    params.require(:enterprise).permit(:company_name, :customer_account, :active, :location_code,
                                       :location_name, :address_1, :address_2, :city, :state, :postal, :country,
                                       :user_id, :residential, :comments, :earliest_appt, :latest_appt, :location_type,
                                       :contact_type, :contact_name, :contact_phone, :contact_fax, :contact_email,
                                       :parent_name, parent_acct_num)
  end
end
