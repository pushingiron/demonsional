# frozen_string_literal: true
class ConfigurationsController < ApplicationController
  before_action :set_configuration, except: %i[index new create]
  before_action :authenticate_user!

  def index
    @configurations = current_user.configurations.first
  end

  def new
    @configuration = current_user.configurations.new
  end

  def edit
  end

  def show

  end

  def create
    @configuration = current_user.configurations.new(configurations_params)

    respond_to do |format|
      if @configuration.save
        format.html { redirect_to @configuration, notice: "Configuration was successfully created." }
        format.json { render :show, status: :created, location: @configuration }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @configuration.update(configurations_params)
        format.html { redirect_to @configuration, notice: "Configuration was successfully updated." }
        format.json { render :show, status: :ok, location: @configuration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_configuration
    @configuration = current_user.configurations.find(params[:id])
  end

  def configurations_params
    params.require(:configuration).permit(:parent, :user_id)
  end

end

